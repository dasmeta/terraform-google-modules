locals {
  route_name = "${var.name}-scc-alerts"
  services = toset([
    "securitycenter.googleapis.com",
    "pubsub.googleapis.com",
    "cloudfunctions.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudscheduler.googleapis.com",
    "firestore.googleapis.com",
    "secretmanager.googleapis.com",
    "monitoring.googleapis.com",
    "storage.googleapis.com",
    "cloudkms.googleapis.com",
  ])
  cutover_at = coalesce(var.cutover_at, terraform_data.cutover.output)
}

data "google_project" "current" {
  project_id = var.project_id
}

data "google_storage_project_service_account" "gcs" {
  project    = var.project_id
  depends_on = [google_project_service.required]
}

resource "terraform_data" "cutover" {
  input = timestamp()
  lifecycle {
    ignore_changes = [input]
  }
}

resource "google_project_service" "required" {
  for_each           = var.manage_project_services ? local.services : toset([])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_firestore_database" "ledger" {
  count           = var.create_firestore_database ? 1 : 0
  project         = var.project_id
  name            = var.firestore_database
  location_id     = var.firestore_location
  type            = "FIRESTORE_NATIVE"
  deletion_policy = "ABANDON"
  depends_on      = [google_project_service.required]
}

resource "google_firestore_field" "finding_ttl" {
  project    = var.project_id
  database   = var.firestore_database
  collection = "${replace(local.route_name, "-", "_")}_findings"
  field      = "expires_at"
  ttl_config {}
  depends_on = [google_firestore_database.ledger]
}

resource "google_service_account" "runtime" {
  project      = var.project_id
  account_id   = "${var.name}-scc-runtime"
  display_name = "${var.name} SCC alert runtime"
}

resource "google_service_account" "caller" {
  project      = var.project_id
  account_id   = "${var.name}-scc-caller"
  display_name = "${var.name} SCC Pub/Sub and scheduler caller"
}

resource "google_project_iam_member" "runtime" {
  for_each = toset(["roles/datastore.user", "roles/securitycenter.findingsViewer", "roles/logging.logWriter"])
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_secret_manager_secret_iam_member" "slack" {
  project   = var.project_id
  secret_id = var.slack_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_secret_manager_secret_iam_member" "opsgenie" {
  count     = var.opsgenie_secret_id == null ? 0 : 1
  project   = var.project_id
  secret_id = var.opsgenie_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_kms_crypto_key_iam_member" "source_bucket" {
  crypto_key_id = var.source_bucket_kms_key_name
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = data.google_storage_project_service_account.gcs.member
}

resource "google_storage_bucket" "source" {
  project                     = var.project_id
  name                        = "${substr(var.project_id, 0, 25)}-${var.name}-scc-${substr(md5(var.project_id), 0, 8)}"
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = true
  encryption {
    default_kms_key_name = var.source_bucket_kms_key_name
  }
  lifecycle {
    precondition {
      condition     = can(regex("/locations/${var.region}/", var.source_bucket_kms_key_name))
      error_message = "source_bucket_kms_key_name must be in the same region as the source bucket."
    }
  }
  depends_on = [google_project_service.required, google_kms_crypto_key_iam_member.source_bucket]
}

data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.root}/.terraform/${var.name}-scc-function.zip"
  excludes    = ["__pycache__", "*.pyc"]
}

resource "google_storage_bucket_object" "function" {
  bucket = google_storage_bucket.source.name
  name   = "function-${data.archive_file.function.output_md5}.zip"
  source = data.archive_file.function.output_path
}

resource "google_pubsub_topic" "findings" {
  project    = var.project_id
  name       = "${local.route_name}-findings"
  depends_on = [google_project_service.required]
}

resource "google_pubsub_topic" "dead_letter" {
  project    = var.project_id
  name       = "${local.route_name}-dead-letter"
  depends_on = [google_project_service.required]
}

resource "google_pubsub_subscription" "dead_letter" {
  project                    = var.project_id
  name                       = "${local.route_name}-dead-letter"
  topic                      = google_pubsub_topic.dead_letter.id
  message_retention_duration = "1209600s"
}

resource "google_scc_v2_project_notification_config" "findings" {
  project      = var.project_id
  location     = var.scc_location
  config_id    = local.route_name
  description  = "Grouped security findings routed to Slack and Opsgenie"
  pubsub_topic = google_pubsub_topic.findings.id

  streaming_config {
    filter = var.scc_filter
  }
  depends_on = [google_project_service.required]
}

resource "google_cloudfunctions2_function" "router" {
  project     = var.project_id
  name        = local.route_name
  location    = var.region
  description = "SCC finding ledger, grouped Slack/Opsgenie delivery and reconciliation"

  build_config {
    runtime     = "python312"
    entry_point = "route_request"
    source {
      storage_source {
        bucket = google_storage_bucket.source.name
        object = google_storage_bucket_object.function.name
      }
    }
  }

  service_config {
    available_memory                 = "512M"
    timeout_seconds                  = 540
    max_instance_count               = 2
    max_instance_request_concurrency = 1
    ingress_settings                 = "ALLOW_ALL"
    service_account_email            = google_service_account.runtime.email
    environment_variables = {
      PROJECT_ID         = var.project_id
      SCC_LOCATION       = var.scc_location
      SCC_FILTER         = var.scc_filter
      FIRESTORE_DATABASE = var.firestore_database
      COLLECTION_PREFIX  = replace(local.route_name, "-", "_")
      CUTOVER_AT         = local.cutover_at
      ROUTING_CONFIG     = jsonencode(var.routing)
      OPSGENIE_API_URL   = var.opsgenie_api_url
      OPSGENIE_ENABLED   = var.opsgenie_secret_id == null ? "false" : "true"
    }
    secret_volumes {
      mount_path = "/secrets/slack"
      project_id = var.project_id
      secret     = var.slack_secret_id
      versions {
        version = "latest"
        path    = "webhook"
      }
    }
    dynamic "secret_volumes" {
      for_each = var.opsgenie_secret_id == null ? [] : [var.opsgenie_secret_id]
      content {
        mount_path = "/secrets/opsgenie"
        project_id = var.project_id
        secret     = secret_volumes.value
        versions {
          version = "latest"
          path    = "api_key"
        }
      }
    }
  }
  depends_on = [google_project_service.required, google_project_iam_member.runtime, google_secret_manager_secret_iam_member.slack, google_secret_manager_secret_iam_member.opsgenie, google_firestore_database.ledger, google_firestore_field.finding_ttl]
}

resource "google_cloud_run_v2_service_iam_member" "pubsub_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloudfunctions2_function.router.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.caller.email}"
}

resource "google_service_account_iam_member" "pubsub_token" {
  service_account_id = google_service_account.caller.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_topic_iam_member" "dead_letter_publisher" {
  project = var.project_id
  topic   = google_pubsub_topic.dead_letter.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_subscription" "findings" {
  project                    = var.project_id
  name                       = "${local.route_name}-findings"
  topic                      = google_pubsub_topic.findings.id
  ack_deadline_seconds       = 600
  message_retention_duration = "604800s"

  push_config {
    push_endpoint = google_cloudfunctions2_function.router.service_config[0].uri
    oidc_token {
      service_account_email = google_service_account.caller.email
      audience              = google_cloudfunctions2_function.router.service_config[0].uri
    }
  }
  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dead_letter.id
    max_delivery_attempts = 10
  }
  depends_on = [google_cloud_run_v2_service_iam_member.pubsub_invoker, google_service_account_iam_member.pubsub_token, google_pubsub_topic_iam_member.dead_letter_publisher]
}

resource "google_pubsub_subscription_iam_member" "dead_letter_subscriber" {
  project      = var.project_id
  subscription = google_pubsub_subscription.findings.name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_cloud_scheduler_job" "reconcile" {
  project          = var.project_id
  region           = var.region
  name             = "${local.route_name}-reconcile"
  description      = "Reconcile SCC findings and send the daily security brief"
  schedule         = "*/15 * * * *"
  time_zone        = "Etc/UTC"
  attempt_deadline = "540s"

  http_target {
    uri         = google_cloudfunctions2_function.router.service_config[0].uri
    http_method = "POST"
    headers     = { "Content-Type" = "application/json" }
    body        = base64encode(jsonencode({ action = "reconcile" }))
    oidc_token {
      service_account_email = google_service_account.caller.email
      audience              = google_cloudfunctions2_function.router.service_config[0].uri
    }
  }
  depends_on = [google_cloud_run_v2_service_iam_member.pubsub_invoker, google_project_service.required]
}

resource "google_monitoring_alert_policy" "dead_letter" {
  project               = var.project_id
  display_name          = "${local.route_name} dead-letter backlog"
  combiner              = "OR"
  notification_channels = var.failure_notification_channels
  conditions {
    display_name = "SCC alert dead-letter messages waiting"
    condition_threshold {
      filter          = "resource.type=\"pubsub_subscription\" AND resource.label.subscription_id=\"${google_pubsub_subscription.dead_letter.name}\" AND metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MAX"
      }
    }
  }
  depends_on = [google_project_service.required]
}

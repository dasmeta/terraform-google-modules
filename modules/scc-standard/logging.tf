module "log_export" {
  count = var.logging_integration_enabled ? 1 : 0

  source  = "terraform-google-modules/log-export/google"
  version = "~> 11.0"

  destination_uri        = var.logging_destination
  filter                 = local.logging_filter
  log_sink_name          = local.logging_sink_name
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true

  depends_on = [terraform_data.logging_validation, google_project_service.required]
}

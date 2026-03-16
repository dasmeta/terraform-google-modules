resource "google_logging_project_sink" "security_signals" {
  count = var.logging_integration_enabled ? 1 : 0

  project                = var.project_id
  name                   = var.logging_export_name
  destination            = var.logging_destination
  filter                 = local.security_signal_filter
  unique_writer_identity = true

  depends_on = [
    google_project_service.required,
  ]
}

resource "google_logging_metric" "security_findings" {
  count = var.monitoring_integration_enabled ? 1 : 0

  project = var.project_id
  name    = var.monitoring_metric_name
  filter  = local.security_signal_filter
}

resource "google_monitoring_alert_policy" "security_findings" {
  count = var.monitoring_integration_enabled ? 1 : 0

  project               = var.project_id
  display_name          = var.monitoring_alert_policy_name
  combiner              = "OR"
  enabled               = true
  notification_channels = local.monitoring_notification_channels

  documentation {
    content   = "Alert on Security Command Center related events in project ${var.project_id}."
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "${var.monitoring_alert_policy_name}-condition"

    condition_threshold {
      filter          = "resource.type=\"global\" AND metric.type=\"logging.googleapis.com/user/${google_logging_metric.security_findings[0].name}\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.monitoring_threshold_value
      duration        = "0s"

      aggregations {
        alignment_period   = var.monitoring_alignment_period
        per_series_aligner = "ALIGN_COUNT"
      }

      trigger {
        count = 1
      }
    }
  }

  depends_on = [
    google_project_service.required,
    google_logging_metric.security_findings,
  ]
}

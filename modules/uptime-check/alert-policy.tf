locals {
  notification_channels_email   = var.enable_email_notifiacation ? [google_monitoring_notification_channel.email[0].id] : []
  notification_channels_slack   = var.enable_slack_notifiacation ? [google_monitoring_notification_channel.slack[0].id] : []
  notification_channels_webhook = var.enable_webhook_notifications ? [google_monitoring_notification_channel.webhook[0].id] : []
  all_notification_channels     = concat(local.notification_channels_email, local.notification_channels_slack, local.notification_channels_webhook)
}

resource "google_monitoring_alert_policy" "alert_policy" {
  project      = var.project_id
  display_name = var.name
  combiner     = "OR"

  conditions {
    display_name = var.name

    condition_threshold {
      filter          = var.alert_policy_filter == "" && var.checker_location == "" ? "resource.type = \"uptime_url\" AND metric.type = \"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.labels.check_id = \"${google_monitoring_uptime_check_config.https.uptime_check_id}\"" : var.alert_policy_filter == "" && var.checker_location != "" ? "resource.type = \"uptime_url\" AND metric.type = \"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.labels.check_id = \"${google_monitoring_uptime_check_config.https.uptime_check_id}\" AND metric.labels.checker_location = \"${var.checker_location}\"" : var.alert_policy_filter
      duration        = var.duration
      comparison      = var.comparison
      threshold_value = var.threshold_value

      aggregations {
        alignment_period     = var.aggregations.alignment_period
        group_by_fields      = var.aggregations.group_by_fields
        per_series_aligner   = var.aggregations.per_series_aligner
        cross_series_reducer = var.aggregations.cross_series_reducer
      }

      trigger {
        count   = var.trigger.count
        percent = var.trigger.percent
      }
    }
  }
  documentation {
    content   = var.documentation_content
    mime_type = "text/markdown"
  }
  notification_channels = local.all_notification_channels
}

resource "google_monitoring_uptime_check_config" "https" {
  display_name     = var.display_name != "" ? var.display_name : var.name
  timeout          = var.timeout
  period           = var.period
  selected_regions = var.selected_regions

  http_check {
    path         = var.http_check.path
    port         = var.http_check.port
    use_ssl      = var.http_check.use_ssl
    validate_ssl = var.http_check.validate_ssl
    auth_info {
      username = var.auth_info.username
      password = var.auth_info.password
    }
    accepted_response_status_codes {
      status_class = var.http_check.status_class
      status_value = var.http_check.status_value
    }
  }

  monitored_resource {
    type = var.monitored_resource_type
    labels = {
      project_id = var.project_id
      host       = var.name
    }
  }
}

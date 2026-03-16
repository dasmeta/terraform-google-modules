output "project_number" {
  description = "Numeric project identifier derived from the target project."
  value       = data.google_project.project.number
}

output "required_services" {
  description = "Services the module enables for the SCC Standard baseline."
  value       = sort(tolist(local.required_services))
}

output "service_identity_emails" {
  description = "Google-managed service identity emails created by the baseline."
  value       = { for service, identity in google_project_service_identity.service_identity : service => identity.email }
}

output "effective_operator_identities" {
  description = "Normalized operator identities receiving additive project access."
  value       = local.normalized_operator_identities
}

output "effective_role_bindings" {
  description = "Normalized additive IAM bindings applied by the module."
  value       = local.effective_role_bindings
}

output "logging_integration_enabled" {
  description = "Whether logging integration is enabled for the module instance."
  value       = var.logging_integration_enabled
}

output "logging_export_filter" {
  description = "Filter used by the logging sink and logs-based metric."
  value       = local.security_signal_filter
}

output "logging_sink_writer_identity" {
  description = "Writer identity created for the logging sink when logging integration is enabled."
  value       = try(google_logging_project_sink.security_signals[0].writer_identity, null)
}

output "monitoring_integration_enabled" {
  description = "Whether monitoring integration is enabled for the module instance."
  value       = var.monitoring_integration_enabled
}

output "monitoring_alert_policy_name" {
  description = "Display name of the monitoring alert policy created by the module."
  value       = try(google_monitoring_alert_policy.security_findings[0].display_name, null)
}

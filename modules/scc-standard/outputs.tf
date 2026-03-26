output "project_id" {
  description = "Target project prepared by this module."
  value       = var.project_id
}

output "required_services" {
  description = "Required project services enabled by the module."
  value       = local.required_services
}

output "manual_activation_required" {
  description = "Whether SCC tier activation remains an external manual prerequisite."
  value       = true
}

output "manual_prerequisites" {
  description = "Manual prerequisites that remain outside Terraform automation."
  value       = local.manual_prerequisites
}

output "operator_identities" {
  description = "Approved operator identities managed by this module."
  value       = local.unique_operator_identities
}

output "operator_role_bindings" {
  description = "Additive operator role bindings derived by this module."
  value       = local.operator_bindings
}

output "logging_filter" {
  description = "Logging filter used when the optional log export is enabled."
  value       = local.logging_filter
}

output "logging_sink_name" {
  description = "Deterministic log sink name used by the optional logging integration."
  value       = var.logging_integration_enabled ? local.logging_sink_name : null
}

output "logging_destination" {
  description = "Configured logging destination for the optional log export."
  value       = var.logging_integration_enabled ? var.logging_destination : null
}

output "logging_writer_identity" {
  description = "Writer identity produced by the optional log export module."
  value       = var.logging_integration_enabled ? module.log_export[0].writer_identity : null
}

output "baseline_summary" {
  description = "High-level summary of the prepared baseline managed by this module."
  value = {
    project_id                 = var.project_id
    manual_activation_required = true
    required_services          = local.required_services
    operator_identities        = local.unique_operator_identities
    logging_integration        = var.logging_integration_enabled
    logging_sink_name          = var.logging_integration_enabled ? local.logging_sink_name : null
  }
}

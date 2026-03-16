variable "project_id" {
  type        = string
  description = "Target Google Cloud project ID where the SCC Standard baseline will be configured."
}

variable "additional_services" {
  type        = list(string)
  default     = []
  description = "Additional Google APIs to enable alongside the baseline-required services."
}

variable "disable_services_on_destroy" {
  type        = bool
  default     = false
  description = "Whether enabled APIs should be disabled when the module is destroyed."
}

variable "service_identity_services" {
  type        = list(string)
  default     = ["securitycenter.googleapis.com"]
  description = "Services for which Google-managed service identities should be created."
}

variable "operator_identities" {
  type        = list(string)
  default     = []
  description = "Additional IAM member strings that should receive project-level SCC operator access."
}

variable "operator_roles" {
  type        = list(string)
  default     = ["roles/securitycenter.findingsViewer"]
  description = "Project roles granted to each operator identity."
}

variable "baseline_role_bindings" {
  type        = map(list(string))
  default     = {}
  description = "Additional project role bindings to apply as additive IAM memberships."
}

variable "logging_integration_enabled" {
  type        = bool
  default     = false
  description = "Whether to configure a logging export for SCC-related audit and findings signals."
}

variable "logging_destination" {
  type        = string
  default     = null
  description = "Logging sink destination URI used when logging integration is enabled."

  validation {
    condition     = !var.logging_integration_enabled || var.logging_destination != null
    error_message = "logging_destination must be provided when logging_integration_enabled is true."
  }
}

variable "logging_filter" {
  type        = string
  default     = null
  description = "Optional override for the default SCC-related logging export filter."
}

variable "logging_export_name" {
  type        = string
  default     = "scc-findings-export"
  description = "Name used for the logging sink created by the module."
}

variable "monitoring_integration_enabled" {
  type        = bool
  default     = false
  description = "Whether to configure monitoring alerts for SCC-related signals."
}

variable "monitoring_destination" {
  type        = string
  default     = null
  description = "Monitoring notification channel ID used when monitoring integration is enabled."

  validation {
    condition     = !var.monitoring_integration_enabled || var.monitoring_destination != null
    error_message = "monitoring_destination must be provided when monitoring_integration_enabled is true."
  }
}

variable "monitoring_metric_name" {
  type        = string
  default     = "scc_findings"
  description = "Name of the logs-based metric created for monitoring integration."
}

variable "monitoring_alert_policy_name" {
  type        = string
  default     = "scc-findings-alert"
  description = "Display name of the monitoring alert policy created by the module."
}

variable "monitoring_threshold_value" {
  type        = number
  default     = 0
  description = "Threshold value used by the monitoring alert policy for SCC-related events."
}

variable "monitoring_alignment_period" {
  type        = string
  default     = "300s"
  description = "Alignment period used by the monitoring alert policy aggregation."
}

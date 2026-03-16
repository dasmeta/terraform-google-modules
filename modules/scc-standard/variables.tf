variable "project_id" {
  description = "Target Google Cloud project for the prepared SCC baseline."
  type        = string
}

variable "operator_identities" {
  description = "Approved operator identities that should receive SCC-related project access."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for member in var.operator_identities : can(regex("^[^:]+:.+$", member))])
    error_message = "operator_identities must use canonical IAM member syntax such as group:team@example.com."
  }
}

variable "logging_integration_enabled" {
  description = "Whether to create the optional logging export integration."
  type        = bool
  default     = false
}

variable "logging_destination" {
  description = "Logging export destination URI used when logging integration is enabled."
  type        = string
  default     = null
}

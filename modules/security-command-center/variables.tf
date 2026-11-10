variable "project_id" {
  type        = string
  description = "Project whose Security Command Center v2 findings are routed."
}

variable "name" {
  type        = string
  description = "Short, unique route name (lowercase letters, digits, hyphens; at most 18 characters)."
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,17}$", var.name))
    error_message = "name must start with a lowercase letter and contain at most 18 lowercase letters, digits, or hyphens."
  }
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "Region for the Cloud Run function, scheduler, and source bucket."
}

variable "scc_location" {
  type        = string
  default     = "global"
  description = "SCC v2 location used for notification export and reconciliation."
}

variable "scc_filter" {
  type        = string
  default     = "state = \"ACTIVE\" OR state = \"INACTIVE\""
  description = "SCC notification and reconciliation filter. Keep INACTIVE updates to permit lifecycle closure."
  validation {
    condition     = trimspace(var.scc_filter) != ""
    error_message = "scc_filter must not be empty."
  }
}

variable "slack_secret_id" {
  type        = string
  description = "Existing Secret Manager secret name containing the dedicated security Slack webhook."
}

variable "source_bucket_kms_key_name" {
  type        = string
  description = "Existing Cloud KMS CryptoKey resource name for the function source bucket; the key must be in the bucket region."
  validation {
    condition     = can(regex("^projects/[^/]+/locations/[^/]+/keyRings/[^/]+/cryptoKeys/[^/]+$", var.source_bucket_kms_key_name))
    error_message = "source_bucket_kms_key_name must be a CryptoKey resource name."
  }
}

variable "opsgenie_secret_id" {
  type        = string
  default     = null
  description = "Existing Secret Manager secret name containing an Opsgenie Alert API key; null disables Opsgenie."
}

variable "opsgenie_api_url" {
  type        = string
  default     = "https://api.opsgenie.com"
  description = "Opsgenie US or EU Alert API base URL."
  validation {
    condition     = contains(["https://api.opsgenie.com", "https://api.eu.opsgenie.com"], var.opsgenie_api_url)
    error_message = "opsgenie_api_url must be the official US or EU Opsgenie API URL."
  }
}

variable "firestore_database" {
  type        = string
  default     = "(default)"
  description = "Firestore Native database name for the delivery ledger."
}

variable "create_firestore_database" {
  type        = bool
  default     = false
  description = "Create the Firestore Native database; set false to reuse an existing database."
}

variable "firestore_location" {
  type        = string
  default     = "eur3"
  description = "Firestore database location when create_firestore_database is true."
}

variable "manage_project_services" {
  type        = bool
  default     = true
  description = "Enable required Google APIs without disabling them on destroy."
}

variable "cutover_at" {
  type        = string
  default     = null
  description = "UTC RFC3339 creation cutoff; null captures the first Terraform apply and preserves it in state."
  validation {
    condition     = var.cutover_at == null || can(formatdate("YYYY-MM-DD'T'hh:mm:ss'Z'", var.cutover_at))
    error_message = "cutover_at must be an RFC3339 timestamp."
  }
}

variable "routing" {
  type = object({
    environment_label        = optional(string, "")  # Environment displayed in alerts.
    project_label            = optional(string, "")  # Friendly project label displayed in alerts.
    quiet_period_minutes     = optional(number, 60)  # Quiet minutes before closing an Opsgenie group.
    reconcile_lookback_hours = optional(number, 24)  # SCC event-time lookback for scheduled recovery.
    finding_retention_days   = optional(number, 365) # Days to retain inactive finding snapshots for deduplication.
    daily_digest = optional(object({
      enabled    = optional(bool, true) # Send a grouped Slack brief each UTC day.
      hour_utc   = optional(number, 8)  # Earliest UTC hour for the brief.
      max_groups = optional(number, 20) # Maximum groups shown in the brief.
    }), {})                             # Daily UTC grouped Slack summary.
    realtime = optional(object({
      critical                      = optional(bool, true) # Send CRITICAL to Slack immediately.
      high_requires_exploit         = optional(bool, true) # HIGH needs positive exploit evidence for immediate Slack.
      high_requires_public_exposure = optional(bool, true) # HIGH needs positive public-exposure evidence for immediate Slack.
    }), {})                                                # Immediate Slack delivery rules.
    paging = optional(object({
      critical                = optional(bool, true)   # Page CRITICAL groups.
      high_exploitable        = optional(bool, true)   # Page HIGH groups only with positive exploit evidence.
      require_public_exposure = optional(bool, true)   # HIGH paging needs positive public-exposure evidence.
      high_priority           = optional(string, "P1") # Opsgenie priority for qualifying HIGH groups.
    }), {})                                            # Opsgenie paging rules.
  })
  default     = {}
  description = "Grouped Slack and Opsgenie delivery policy."
  validation {
    condition     = var.routing.quiet_period_minutes >= 15 && var.routing.daily_digest.hour_utc >= 0 && var.routing.daily_digest.hour_utc <= 23 && var.routing.daily_digest.max_groups >= 1 && var.routing.daily_digest.max_groups <= 100 && var.routing.reconcile_lookback_hours >= 1 && var.routing.reconcile_lookback_hours <= 168 && var.routing.finding_retention_days >= 30
    error_message = "quiet period must be at least 15 minutes, digest hour 0-23, max groups 1-100, lookback 1-168 hours, and retention at least 30 days."
  }
  validation {
    condition     = contains(["P1", "P2"], var.routing.paging.high_priority)
    error_message = "routing.paging.high_priority must be P1 or P2."
  }
}

variable "failure_notification_channels" {
  type        = list(string)
  default     = []
  description = "Cloud Monitoring notification channel IDs for dead-letter backlog alarms."
}

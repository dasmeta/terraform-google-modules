variable "name" {
  type        = string
  description = "A short name or phrase used to identify the uptime check and policy in dashboards, notifications, and incidents."
  default     = "https-uptime-check"
}

variable "display_name" {
  type        = string
  description = "Display name for an uptime check in GCP console."
  default     = ""
}

variable "selected_regions" {
  type        = list(string)
  description = "The list of regions from which the check will be run. Not specifying this field will result in uptime checks running from all regions."
  default     = []
}

variable "checker_location" {
  type        = string
  description = "Checker location filter for uptime check metric. If specified, this filter will be added to the alert policy config. Can be one of: apac-singapore, eur-belgium, sa-brazil-sao_paulo, usa-iowa, usa-oregon, usa-virginia."
  default     = ""
}

variable "project_id" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default     = null
}

variable "timeout" {
  type        = string
  description = "The maximum amount of time to wait for the request to complete (must be between 1 and 60 seconds)."
  default     = "20s"
}

variable "period" {
  type        = string
  description = "How often, in seconds, the uptime check is performed."
  default     = "60s"
}

variable "duration" {
  type        = string
  description = "The amount of time that a time series must fail to report new data to be considered failing."
  default     = "300s"
}

variable "comparison" {
  type        = string
  description = "The comparison to apply between the time series (indicated by filter and aggregation) and the threshold (indicated by threshold_value)."
  default     = "COMPARISON_LT"
}

variable "threshold_value" {
  type        = string
  description = "The comparison to apply between the time series (indicated by filter and aggregation) and the threshold (indicated by threshold_value)."
  default     = 4
}

variable "http_check" {
  type = object({
    path         = optional(string, "/")                # The path to the page to run the check against. Will be combined with the host
    port         = optional(string, "443")              # The port to the page to run the check against. Will be combined with host
    use_ssl      = optional(bool, true)                 # If true, use HTTPS instead of HTTP to run the check.
    validate_ssl = optional(bool, true)                 # Specifies whether to include SSL certificate validation as a part of the Uptime check.
    status_class = optional(string, "STATUS_CLASS_2XX") # A class of status codes to accept.
    status_value = optional(number, 0)                  # A status code to accept.
  })
  default = {
    path         = "/"
    port         = "443"
    use_ssl      = true
    validate_ssl = true
    status_class = "STATUS_CLASS_2XX"
    status_value = 0
  }
  description = "Contains information needed to make an HTTP or HTTPS check."
}

variable "monitored_resource_type" {
  type        = string
  description = "The monitored resource type."
  default     = "uptime_url"
}

variable "alert_policy_filter" {
  type        = string
  description = "A filter that identifies which time series should be compared with the threshold."
  default     = ""
}

# Email Notifications
variable "enable_email_notifiacation" {
  type        = bool
  description = "Whether enable email notifications or not."
  default     = true
}

variable "email_addres" {
  type        = string
  description = "Email address to which the notifications will be sent."
  default     = null
}

# Slack Notifications
variable "enable_slack_notifiacation" {
  type        = bool
  description = "Whether enable slack notifications or not."
  default     = false
}

variable "channel_name" {
  type        = string
  description = "Slack channel name to which notifications will be sent."
  default     = null
}

variable "auth_token" {
  type        = string
  description = "Slack app bot's token used to integrate GCP notifications with slack channel"
  default     = null
}

# Webhook Notifications
variable "enable_webhook_notifications" {
  type        = bool
  sensitive   = true
  description = "Whether enable webhook notifications or not."
  default     = true
}

variable "webhook_integration_url" {
  type        = string
  description = "Webhook integration's url for GCP monitoring norifications."
  default     = null
}

variable "aggregations" {
  type = object({
    alignment_period     = optional(string, "300s")             # The alignment period for per-time series alignment. If present, alignmentPeriod must be at least 60 seconds.
    group_by_fields      = optional(list(string), [])           # The set of fields to preserve when crossSeriesReducer is specified.
    cross_series_reducer = optional(string, "")                 # The approach to be used to combine time series.
    per_series_aligner   = optional(string, "ALIGN_COUNT_TRUE") # The approach to be used to align individual time series.
  })
  description = "Specifies the alignment of data points in individual time series as well as how to combine the retrieved time series together."
  default = {
    alignment_period     = "60s"
    cross_series_reducer = ""
    group_by_fields      = []
    per_series_aligner   = "ALIGN_COUNT"
  }
}

variable "trigger" {
  type = object({
    percent = optional(number, 0) # The percentage of time series that must fail the predicate for the condition to be triggered.
    count   = optional(number, 1) # The absolute number of time series that must fail the predicate for the condition to be triggered.
  })
  description = "The number/percent of time series for which the comparison must hold in order for the condition to trigger."
  default = {
    percent = 0
    count   = 1
  }
}

variable "documentation_content" {
  type        = string
  description = "The text of the alert documentation."
  default     = ""
}

variable "auth_info" {
  type = object({
    username = string # The username to authenticate.
    password = string # The password to authenticate.
  })
  description = "The authentication information using username and password."
  default = {
    username = ""
    password = ""
  }
}

This module creates http and https uptime checks in gcp.

# Example
```
locals {
  hosts_and_paths = [
    {
      name         = "example.com"
      host         = "example.com"
      health_check = true
      path         = "/"
    },
    {
      name         = "example.com/mobile/"
      host         = "example.com"
      health_check = true
      path         = "/mobile/"
    },
  ]
}

module "uptime_checks" {
  source = "dasmeta/modules/google//modules/uptime-check"

  for_each = { for item in local.hosts_and_paths : item.name => item if item.health_check }

  enable_email_notification = false
  enable_slack_notification = true
  project_id                 = "my-project"
  name                       = each.value.host
  display_name               = each.value.name
  channel_name               = "xxxxx"
  auth_token                 = "xxxxx"
  http_check = {
    path = each.value.path
  }
  documentation_content = each.value.name
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name                                                       | Version |
| ---------------------------------------------------------- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                           | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [google_monitoring_alert_policy.alert_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy)          | resource    |
| [google_monitoring_notification_channel.email](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource    |
| [google_monitoring_notification_channel.slack](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource    |
| [google_monitoring_uptime_check_config.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_uptime_check_config)   | resource    |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project)                                            | data source |

## Inputs

| Name                                                                                                                 | Description         | Type     | Default                | Required |
| -------------------------------------------------------------------------------------------------------------------- | ------------------- | -------- | ---------------------- | :------: |
| <a name="input_alert_policy_filter"></a> [alert\_policy\_filter](#input\_alert\_policy\_filter)                      | n/a                 | `string` | `""`                   |    no    |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token)                                                   | n/a                 | `string` | `""`                   |    no    |
| <a name="input_channel_name"></a> [channel\_name](#input\_channel\_name)                                             | n/a                 | `string` | `""`                   |    no    |
| <a name="input_email_addres"></a> [email\_addres](#input\_email\_addres)                                             | n/a                 | `string` | `""`                   |    no    |
| <a name="input_enable_email_notifiacation"></a> [enable\_email\_notifiacation](#input\_enable\_email\_notifiacation) | Email Notifications | `bool`   | `true`                 |    no    |
| <a name="input_enable_slack_notifiacation"></a> [enable\_slack\_notifiacation](#input\_enable\_slack\_notifiacation) | Slack Notification  | `bool`   | `false`                |    no    |
| <a name="input_http_check_path"></a> [http\_check\_path](#input\_http\_check\_path)                                  | n/a                 | `string` | `"/"`                  |    no    |
| <a name="input_http_check_port"></a> [http\_check\_port](#input\_http\_check\_port)                                  | n/a                 | `string` | `"443"`                |    no    |
| <a name="input_http_check_status_class"></a> [http\_check\_status\_class](#input\_http\_check\_status\_class)        | n/a                 | `string` | `"STATUS_CLASS_2XX"`   |    no    |
| <a name="input_http_check_use_ssl"></a> [http\_check\_use\_ssl](#input\_http\_check\_use\_ssl)                       | n/a                 | `bool`   | `true`                 |    no    |
| <a name="input_http_check_validate_ssl"></a> [http\_check\_validate\_ssl](#input\_http\_check\_validate\_ssl)        | n/a                 | `bool`   | `true`                 |    no    |
| <a name="input_monitored_resource_host"></a> [monitored\_resource\_host](#input\_monitored\_resource\_host)          | n/a                 | `string` | `""`                   |    no    |
| <a name="input_monitored_resource_type"></a> [monitored\_resource\_type](#input\_monitored\_resource\_type)          | n/a                 | `string` | `"uptime_url"`         |    no    |
| <a name="input_name"></a> [name](#input\_name)                                                                       | n/a                 | `string` | `"https-uptime-check"` |    no    |
| <a name="input_timeout"></a> [timeout](#input\_timeout)                                                              | n/a                 | `string` | `"60s"`                |    no    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_monitoring_alert_policy.alert_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_notification_channel.email](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_monitoring_notification_channel.slack](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_monitoring_notification_channel.webhook](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_monitoring_uptime_check_config.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_uptime_check_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aggregations"></a> [aggregations](#input\_aggregations) | Specifies the alignment of data points in individual time series as well as how to combine the retrieved time series together. | <pre>object({<br>    alignment_period     = optional(string, "300s")             # The alignment period for per-time series alignment. If present, alignmentPeriod must be at least 60 seconds.<br>    group_by_fields      = optional(list(string), [])           # The set of fields to preserve when crossSeriesReducer is specified.<br>    cross_series_reducer = optional(string, "")                 # The approach to be used to combine time series.<br>    per_series_aligner   = optional(string, "ALIGN_COUNT_TRUE") # The approach to be used to align individual time series.<br>  })</pre> | <pre>{<br>  "alignment_period": "60s",<br>  "cross_series_reducer": "",<br>  "group_by_fields": [],<br>  "per_series_aligner": "ALIGN_COUNT"<br>}</pre> | no |
| <a name="input_alert_policy_filter"></a> [alert\_policy\_filter](#input\_alert\_policy\_filter) | A filter that identifies which time series should be compared with the threshold. | `string` | `""` | no |
| <a name="input_auth_info"></a> [auth\_info](#input\_auth\_info) | The authentication information using username and password. | <pre>object({<br>    username = string # The username to authenticate.<br>    password = string # The password to authenticate.<br>  })</pre> | <pre>{<br>  "password": "",<br>  "username": ""<br>}</pre> | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | Slack app bot's token used to integrate GCP notifications with slack channel | `string` | `null` | no |
| <a name="input_channel_name"></a> [channel\_name](#input\_channel\_name) | Slack channel name to which notifications will be sent. | `string` | `null` | no |
| <a name="input_checker_location"></a> [checker\_location](#input\_checker\_location) | Checker location filter for uptime check metric. If specified, this filter will be added to the alert policy config. Can be one of: apac-singapore, eur-belgium, sa-brazil-sao\_paulo, usa-iowa, usa-oregon, usa-virginia. | `string` | `""` | no |
| <a name="input_comparison"></a> [comparison](#input\_comparison) | The comparison to apply between the time series (indicated by filter and aggregation) and the threshold (indicated by threshold\_value). | `string` | `"COMPARISON_LT"` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for an uptime check in GCP console. | `string` | `""` | no |
| <a name="input_documentation_content"></a> [documentation\_content](#input\_documentation\_content) | The text of the alert documentation. | `string` | `""` | no |
| <a name="input_duration"></a> [duration](#input\_duration) | The amount of time that a time series must fail to report new data to be considered failing. | `string` | `"300s"` | no |
| <a name="input_email_addres"></a> [email\_addres](#input\_email\_addres) | Email address to which the notifications will be sent. | `string` | `null` | no |
| <a name="input_enable_email_notifiacation"></a> [enable\_email\_notifiacation](#input\_enable\_email\_notifiacation) | Whether enable email notifications or not. | `bool` | `true` | no |
| <a name="input_enable_slack_notifiacation"></a> [enable\_slack\_notifiacation](#input\_enable\_slack\_notifiacation) | Whether enable slack notifications or not. | `bool` | `false` | no |
| <a name="input_enable_webhook_notifications"></a> [enable\_webhook\_notifications](#input\_enable\_webhook\_notifications) | Whether enable webhook notifications or not. | `bool` | `true` | no |
| <a name="input_http_check"></a> [http\_check](#input\_http\_check) | Contains information needed to make an HTTP or HTTPS check. | <pre>object({<br>    path         = optional(string, "/")                # The path to the page to run the check against. Will be combined with the host<br>    port         = optional(string, "443")              # The port to the page to run the check against. Will be combined with host<br>    use_ssl      = optional(bool, true)                 # If true, use HTTPS instead of HTTP to run the check.<br>    validate_ssl = optional(bool, true)                 # Specifies whether to include SSL certificate validation as a part of the Uptime check.<br>    status_class = optional(string, "STATUS_CLASS_2XX") # A class of status codes to accept.<br>    status_value = optional(number, 0)                  # A status code to accept.<br>  })</pre> | <pre>{<br>  "path": "/",<br>  "port": "443",<br>  "status_class": "STATUS_CLASS_2XX",<br>  "status_value": 0,<br>  "use_ssl": true,<br>  "validate_ssl": true<br>}</pre> | no |
| <a name="input_monitored_resource_type"></a> [monitored\_resource\_type](#input\_monitored\_resource\_type) | The monitored resource type. | `string` | `"uptime_url"` | no |
| <a name="input_name"></a> [name](#input\_name) | A short name or phrase used to identify the uptime check and policy in dashboards, notifications, and incidents. | `string` | `"https-uptime-check"` | no |
| <a name="input_period"></a> [period](#input\_period) | How often, in seconds, the uptime check is performed. | `string` | `"60s"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | `null` | no |
| <a name="input_selected_regions"></a> [selected\_regions](#input\_selected\_regions) | The list of regions from which the check will be run. Not specifying this field will result in uptime checks running from all regions. | `list(string)` | `[]` | no |
| <a name="input_threshold_value"></a> [threshold\_value](#input\_threshold\_value) | The comparison to apply between the time series (indicated by filter and aggregation) and the threshold (indicated by threshold\_value). | `string` | `4` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The maximum amount of time to wait for the request to complete (must be between 1 and 60 seconds). | `string` | `"20s"` | no |
| <a name="input_trigger"></a> [trigger](#input\_trigger) | The number/percent of time series for which the comparison must hold in order for the condition to trigger. | <pre>object({<br>    percent = optional(number, 0) # The percentage of time series that must fail the predicate for the condition to be triggered.<br>    count   = optional(number, 1) # The absolute number of time series that must fail the predicate for the condition to be triggered.<br>  })</pre> | <pre>{<br>  "count": 1,<br>  "percent": 0<br>}</pre> | no |
| <a name="input_webhook_integration_url"></a> [webhook\_integration\_url](#input\_webhook\_integration\_url) | Webhook integration's url for GCP monitoring norifications. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

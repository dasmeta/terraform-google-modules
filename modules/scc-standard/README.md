# SCC Standard

This module enables a project-scoped Security Command Center baseline by turning on the required Google APIs, creating service identities for SCC services, applying additive IAM bindings for approved operators, and wiring optional logging and monitoring integrations.

The implementation is intentionally narrow:

- one Terraform module instance manages one project
- project IAM changes are additive only
- logging and monitoring integrations are optional
- organization-wide SCC administration remains outside this module

## Usage

```hcl
module "project_scc_standard" {
  source = "dasmeta/modules/google//modules/scc-standard"

  project_id = "example-project-id"

  operator_identities = [
    "group:secops@example.com",
  ]

  logging_integration_enabled    = true
  logging_destination            = "storage.googleapis.com/example-security-bucket"
  monitoring_integration_enabled = true
  monitoring_destination         = "projects/example-project-id/notificationChannels/1234567890"
}
```

## Design Notes

- API activation is managed with `google_project_service`.
- Google-managed service identities are created with `google_project_service_identity`.
- IAM role assignments use additive `google_project_iam_member` resources.
- Logging integration creates a project log sink for SCC-related signals.
- Monitoring integration creates a logs-based metric and an alert policy connected to an existing notification channel.

## Limitations

- Terraform does not expose every SCC tier-selection workflow as a project-level resource. This module focuses on the project-level prerequisites, IAM, and integrations that are consistently automatable.
- If your organization requires additional SCC organization-level setup, manage that separately before using this module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional_services | Additional Google APIs to enable alongside the baseline-required services. | `list(string)` | `[]` | no |
| baseline_role_bindings | Additional project role bindings to apply as additive IAM memberships. | `map(list(string))` | `{}` | no |
| disable_services_on_destroy | Whether enabled APIs should be disabled when the module is destroyed. | `bool` | `false` | no |
| logging_destination | Logging sink destination URI used when logging integration is enabled. | `string` | `null` | no |
| logging_export_name | Name used for the logging sink created by the module. | `string` | `"scc-findings-export"` | no |
| logging_filter | Optional override for the default SCC-related logging export filter. | `string` | `null` | no |
| logging_integration_enabled | Whether to configure a logging export for SCC-related audit and findings signals. | `bool` | `false` | no |
| monitoring_alert_policy_name | Display name of the monitoring alert policy created by the module. | `string` | `"scc-findings-alert"` | no |
| monitoring_alignment_period | Alignment period used by the monitoring alert policy aggregation. | `string` | `"300s"` | no |
| monitoring_destination | Monitoring notification channel ID used when monitoring integration is enabled. | `string` | `null` | no |
| monitoring_integration_enabled | Whether to configure monitoring alerts for SCC-related signals. | `bool` | `false` | no |
| monitoring_metric_name | Name of the logs-based metric created for monitoring integration. | `string` | `"scc_findings"` | no |
| monitoring_threshold_value | Threshold value used by the monitoring alert policy for SCC-related events. | `number` | `0` | no |
| operator_identities | Additional IAM member strings that should receive project-level SCC operator access. | `list(string)` | `[]` | no |
| operator_roles | Project roles granted to each operator identity. | `list(string)` | `["roles/securitycenter.findingsViewer"]` | no |
| project_id | Target Google Cloud project ID where the SCC Standard baseline will be configured. | `string` | n/a | yes |
| service_identity_services | Services for which Google-managed service identities should be created. | `list(string)` | `["securitycenter.googleapis.com"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| effective_operator_identities | Normalized operator identities receiving additive project access. |
| effective_role_bindings | Normalized additive IAM bindings applied by the module. |
| logging_export_filter | Filter used by the logging sink and logs-based metric. |
| logging_integration_enabled | Whether logging integration is enabled for the module instance. |
| logging_sink_writer_identity | Writer identity created for the logging sink when logging integration is enabled. |
| monitoring_alert_policy_name | Display name of the monitoring alert policy created by the module. |
| monitoring_integration_enabled | Whether monitoring integration is enabled for the module instance. |
| project_number | Numeric project identifier derived from the target project. |
| required_services | Services the module enables for the SCC Standard baseline. |
| service_identity_emails | Google-managed service identity emails created by the baseline. |
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 7.23.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | 7.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_project_service_identity.service_identity](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_project_service_identity) | resource |
| [google_logging_metric.security_findings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_metric) | resource |
| [google_logging_project_sink.security_signals](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink) | resource |
| [google_monitoring_alert_policy.security_findings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_project_iam_member.project_role_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.required](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_services"></a> [additional\_services](#input\_additional\_services) | Additional Google APIs to enable alongside the baseline-required services. | `list(string)` | `[]` | no |
| <a name="input_baseline_role_bindings"></a> [baseline\_role\_bindings](#input\_baseline\_role\_bindings) | Additional project role bindings to apply as additive IAM memberships. | `map(list(string))` | `{}` | no |
| <a name="input_disable_services_on_destroy"></a> [disable\_services\_on\_destroy](#input\_disable\_services\_on\_destroy) | Whether enabled APIs should be disabled when the module is destroyed. | `bool` | `false` | no |
| <a name="input_logging_destination"></a> [logging\_destination](#input\_logging\_destination) | Logging sink destination URI used when logging integration is enabled. | `string` | `null` | no |
| <a name="input_logging_export_name"></a> [logging\_export\_name](#input\_logging\_export\_name) | Name used for the logging sink created by the module. | `string` | `"scc-findings-export"` | no |
| <a name="input_logging_filter"></a> [logging\_filter](#input\_logging\_filter) | Optional override for the default SCC-related logging export filter. | `string` | `null` | no |
| <a name="input_logging_integration_enabled"></a> [logging\_integration\_enabled](#input\_logging\_integration\_enabled) | Whether to configure a logging export for SCC-related audit and findings signals. | `bool` | `false` | no |
| <a name="input_monitoring_alert_policy_name"></a> [monitoring\_alert\_policy\_name](#input\_monitoring\_alert\_policy\_name) | Display name of the monitoring alert policy created by the module. | `string` | `"scc-findings-alert"` | no |
| <a name="input_monitoring_alignment_period"></a> [monitoring\_alignment\_period](#input\_monitoring\_alignment\_period) | Alignment period used by the monitoring alert policy aggregation. | `string` | `"300s"` | no |
| <a name="input_monitoring_destination"></a> [monitoring\_destination](#input\_monitoring\_destination) | Monitoring notification channel ID used when monitoring integration is enabled. | `string` | `null` | no |
| <a name="input_monitoring_integration_enabled"></a> [monitoring\_integration\_enabled](#input\_monitoring\_integration\_enabled) | Whether to configure monitoring alerts for SCC-related signals. | `bool` | `false` | no |
| <a name="input_monitoring_metric_name"></a> [monitoring\_metric\_name](#input\_monitoring\_metric\_name) | Name of the logs-based metric created for monitoring integration. | `string` | `"scc_findings"` | no |
| <a name="input_monitoring_threshold_value"></a> [monitoring\_threshold\_value](#input\_monitoring\_threshold\_value) | Threshold value used by the monitoring alert policy for SCC-related events. | `number` | `0` | no |
| <a name="input_operator_identities"></a> [operator\_identities](#input\_operator\_identities) | Additional IAM member strings that should receive project-level SCC operator access. | `list(string)` | `[]` | no |
| <a name="input_operator_roles"></a> [operator\_roles](#input\_operator\_roles) | Project roles granted to each operator identity. | `list(string)` | <pre>[<br/>  "roles/securitycenter.findingsViewer"<br/>]</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Target Google Cloud project ID where the SCC Standard baseline will be configured. | `string` | n/a | yes |
| <a name="input_service_identity_services"></a> [service\_identity\_services](#input\_service\_identity\_services) | Services for which Google-managed service identities should be created. | `list(string)` | <pre>[<br/>  "securitycenter.googleapis.com"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_effective_operator_identities"></a> [effective\_operator\_identities](#output\_effective\_operator\_identities) | Normalized operator identities receiving additive project access. |
| <a name="output_effective_role_bindings"></a> [effective\_role\_bindings](#output\_effective\_role\_bindings) | Normalized additive IAM bindings applied by the module. |
| <a name="output_logging_export_filter"></a> [logging\_export\_filter](#output\_logging\_export\_filter) | Filter used by the logging sink and logs-based metric. |
| <a name="output_logging_integration_enabled"></a> [logging\_integration\_enabled](#output\_logging\_integration\_enabled) | Whether logging integration is enabled for the module instance. |
| <a name="output_logging_sink_writer_identity"></a> [logging\_sink\_writer\_identity](#output\_logging\_sink\_writer\_identity) | Writer identity created for the logging sink when logging integration is enabled. |
| <a name="output_monitoring_alert_policy_name"></a> [monitoring\_alert\_policy\_name](#output\_monitoring\_alert\_policy\_name) | Display name of the monitoring alert policy created by the module. |
| <a name="output_monitoring_integration_enabled"></a> [monitoring\_integration\_enabled](#output\_monitoring\_integration\_enabled) | Whether monitoring integration is enabled for the module instance. |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | Numeric project identifier derived from the target project. |
| <a name="output_required_services"></a> [required\_services](#output\_required\_services) | Services the module enables for the SCC Standard baseline. |
| <a name="output_service_identity_emails"></a> [service\_identity\_emails](#output\_service\_identity\_emails) | Google-managed service identity emails created by the baseline. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

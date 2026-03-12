## Usage
This example creates
- 2 uptime checks for `example.com` and `example.com/mobile` domains,
- Slack and Webhook notification channels for each uptime check,
- alert policies for each uptime check.

Alert policies notify when the http calls respond not with 200 less than 6 times.
Also, policies check only for South America region's checks in case you have geolocation restriction for the other regions or something like that.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_test"></a> [test](#provider\_test) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_uptime_checks"></a> [uptime\_checks](#module\_uptime\_checks) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| test_assertions.dummy | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

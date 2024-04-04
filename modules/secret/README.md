## GCP Secret Manager Module
This Terraform module simplifies the creation of secrets within Google Cloud Platform's Secret Manager. Specifically, it is designed to create individual secrets and then populate them with an initial version, allowing for the centralized management of sensitive information across your GCP resources.

### Usage Example
To use this module to create secrets in GCP Secret Manager, define a module block in your Terraform configuration file like the example below:
```
module "this" {
  source = "dasmeta/external-secrets/any//modules/gcp-secret"

  secrets = {
    "product-dev-service-username" = "admin"
    "product-dev-service-password" = "root"
  }

  labels = {
    environment = "development"
    team        = "backend"
  }
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_secret_manager_secret.secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.secret_version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_labels"></a> [labels](#input\_labels) | Custom labels to apply to the secret | `map(string)` | `{}` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of secrets where key is the secret name and value is the secret data | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

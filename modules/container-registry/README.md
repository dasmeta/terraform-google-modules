# Example. Create container registry
```
module "my-container-registry" {
  source  = "dasmeta/modules/google//modules/container-registry"
  version = "0.3.0"

  name     = "my-container-registry"
  project  = "my-google-project"
  location = "europe-west3-a"
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_artifact_registry_repository.registry](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Container registry description | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Cloud region the registry will be located | `string` | `"europe-west3-a"` | no |
| <a name="input_name"></a> [name](#input\_name) | Container registry name | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project ID registry will be created in | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_artifact_registry_repository.registry](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Container registry description | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Cloud region the registry will be located | `string` | `"europe-west3-a"` | no |
| <a name="input_name"></a> [name](#input\_name) | Container registry name | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project ID registry will be created in | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

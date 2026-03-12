# Example. Create firebase
```
module "my-firebase" {
  source  = "dasmeta/modules/google//modules/firebase"
  version = "0.3.0"

  project_id      = "" # Google cloud project id
  display_name    = "" # The user-assigned display name of the App.
  bucket_name     = "" # The name of the bucket.
  bucket_location = "" # The GCS location
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_firebase_project.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_firebase_project) | resource |
| [google-beta_google_firebase_web_app.basic](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_firebase_web_app) | resource |
| [google-beta_google_storage_bucket.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_storage_bucket) | resource |
| [google-beta_google_storage_bucket_object.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_storage_bucket_object) | resource |
| [google-beta_google_firebase_web_app_config.basic](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/data-sources/google_firebase_web_app_config) | data source |
| [google_project.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_location"></a> [bucket\_location](#input\_bucket\_location) | (Required) The GCS location. | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | (Required) The name of the bucket. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | (Required) The user-assigned display name of the App. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google cloud project id | `string` | n/a | yes |

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
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_firebase_project.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_firebase_project) | resource |
| [google-beta_google_firebase_web_app.basic](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_firebase_web_app) | resource |
| [google-beta_google_storage_bucket.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_storage_bucket) | resource |
| [google-beta_google_storage_bucket_object.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_storage_bucket_object) | resource |
| [google-beta_google_firebase_web_app_config.basic](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/data-sources/google_firebase_web_app_config) | data source |
| [google_project.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_location"></a> [bucket\_location](#input\_bucket\_location) | (Required) The GCS location. | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | (Required) The name of the bucket. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | (Required) The user-assigned display name of the App. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google cloud project id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

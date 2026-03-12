## Module allows to create/set initial configuration and resources on an new created (or even an existing old one) google cloud account

## minimal example 1) of creation an account owner level access having service account
```hcl
module "bootstrapping" {
  source  = "dasmeta/modules/google//modules/service-accounts"
  version = "0.3.0"

  project_id = "my-google-cloud-project-name"
  names = ["my-super-service-account"]
}
```

## example 2) creation an account owner level access having service account, generation of key and saving/pulling key into ./key.json file
```hcl
module "bootstrapping" {
  source  = "dasmeta/modules/google//modules/service-accounts"
  version = "0.3.0"

  project_id = "my-google-cloud-project-name"
  names = ["my-super-service-account"]
  generate_keys = true
  pull_keys     = true
}
```

## example 3) creation an account editor service account with custom editor role
```hcl
module "bootstrapping" {
  source  = "dasmeta/modules/google//modules/service-accounts"
  version = "0.3.0"

  project_id    = "my-google-cloud-project-name"
  names = ["my-super-service-account"]
  project_roles = ["my-google-cloud-project-name=>roles/editor"]
}
```

## example 3) creation of multiple service accounts with custom names roles
```hcl
module "bootstrapping" {
  source  = "dasmeta/modules/google//modules/service-accounts"
  version = "0.3.0"

  project_id    = "my-google-cloud-project-name"
  names = ["my-super-service-account-viewer", "my-super-service-account-editor"]
  project_roles = ["my-google-cloud-project-name=>roles/viewer", "my-google-cloud-project-name=>roles/editor"]

}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_service_accounts"></a> [service\_accounts](#module\_service\_accounts) | terraform-google-modules/service-accounts/google | 4.1.1 |

## Resources

| Name | Type |
|------|------|
| [local_file.keys](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | If assigning billing role, specify a billing account (default is to assign at the organizational level). | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Default description of the created service accounts (defaults to no description) | `string` | `null` | no |
| <a name="input_descriptions"></a> [descriptions](#input\_descriptions) | List of descriptions for the created service accounts (elements default to the value of `description`) | `list(string)` | `[]` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display names of the created service accounts (defaults to 'Terraform-managed service account') | `string` | `null` | no |
| <a name="input_generate_keys"></a> [generate\_keys](#input\_generate\_keys) | Generate keys for service accounts. | `bool` | `false` | no |
| <a name="input_grant_billing_role"></a> [grant\_billing\_role](#input\_grant\_billing\_role) | Grant billing user role. | `bool` | `false` | no |
| <a name="input_grant_xpn_roles"></a> [grant\_xpn\_roles](#input\_grant\_xpn\_roles) | Grant roles for shared VPC management. | `bool` | `true` | no |
| <a name="input_names"></a> [names](#input\_names) | Names of the service accounts to create. | `list(string)` | `[]` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Id of the organization for org-level roles. | `string` | `""` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service account names. | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id where service account will be created. | `string` | n/a | yes |
| <a name="input_project_roles"></a> [project\_roles](#input\_project\_roles) | Common roles to apply to all service accounts, project=>role as elements. | `list(string)` | `null` | no |
| <a name="input_pull_keys"></a> [pull\_keys](#input\_pull\_keys) | Whether to pull/create local file with service account keys | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_service_accounts"></a> [service\_accounts](#module\_service\_accounts) | terraform-google-modules/service-accounts/google | 4.1.1 |

## Resources

| Name | Type |
|------|------|
| [local_file.keys](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | If assigning billing role, specify a billing account (default is to assign at the organizational level). | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Default description of the created service accounts (defaults to no description) | `string` | `null` | no |
| <a name="input_descriptions"></a> [descriptions](#input\_descriptions) | List of descriptions for the created service accounts (elements default to the value of `description`) | `list(string)` | `[]` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display names of the created service accounts (defaults to 'Terraform-managed service account') | `string` | `null` | no |
| <a name="input_generate_keys"></a> [generate\_keys](#input\_generate\_keys) | Generate keys for service accounts. | `bool` | `false` | no |
| <a name="input_grant_billing_role"></a> [grant\_billing\_role](#input\_grant\_billing\_role) | Grant billing user role. | `bool` | `false` | no |
| <a name="input_grant_xpn_roles"></a> [grant\_xpn\_roles](#input\_grant\_xpn\_roles) | Grant roles for shared VPC management. | `bool` | `true` | no |
| <a name="input_names"></a> [names](#input\_names) | Names of the service accounts to create. | `list(string)` | `[]` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Id of the organization for org-level roles. | `string` | `""` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service account names. | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id where service account will be created. | `string` | n/a | yes |
| <a name="input_project_roles"></a> [project\_roles](#input\_project\_roles) | Common roles to apply to all service accounts, project=>role as elements. | `list(string)` | `null` | no |
| <a name="input_pull_keys"></a> [pull\_keys](#input\_pull\_keys) | Whether to pull/create local file with service account keys | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

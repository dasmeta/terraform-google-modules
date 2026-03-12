
# Example. Create dns zone in gcp
```
module "dns-zone" {
  source = "dasmeta/modules/google//modules/dns-zone"
  version = "0.3.0"

  project_id = "your project_id here"
  name = "example.com"
  key_path = "./key.json"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_dns_managed_zone.this](https://registry.terraform.io/providers/hashicorp/google/4.1.0/docs/resources/dns_managed_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Dns zone description | `string` | `""` | no |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | key.json folder | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | zone name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google cloud project id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_dns_managed_zone.this](https://registry.terraform.io/providers/hashicorp/google/4.1.0/docs/resources/dns_managed_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Dns zone description | `string` | `""` | no |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | key.json folder | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | zone name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google cloud project id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

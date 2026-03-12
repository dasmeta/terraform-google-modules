# Example
```
module "ingress" {
  source = "dasmeta/modules/google//modules/ingress"
  host   = "test.devops.dasmeta.com"
  paths = [
    {
      path         = "/",
      service_name = "nginx",
      service_port = "80"
    }
  ]
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_ingress.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | n/a | `map(any)` | `{}` | no |
| <a name="input_host"></a> [host](#input\_host) | n/a | `string` | `""` | no |
| <a name="input_paths"></a> [paths](#input\_paths) | n/a | `list(any)` | <pre>[<br>  {<br>    "path": "/",<br>    "service_name": "nginx",<br>    "service_port": "80"<br>  }<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_ingress_v1.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | n/a | `map(any)` | `{}` | no |
| <a name="input_host"></a> [host](#input\_host) | n/a | `string` | `""` | no |
| <a name="input_paths"></a> [paths](#input\_paths) | n/a | `list(any)` | <pre>[<br>  {<br>    "path": "/",<br>    "service_name": "nginx",<br>    "service_port": "80"<br>  }<br>]</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

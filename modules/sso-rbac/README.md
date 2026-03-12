This is a module which will configure `GKE RBAC` to sync with Google groups

```
module "gcp-sso-module" {
  source = "dasmeta/modules/google//modules/sso-rbac"
  version = "0.1.0"

  bindings = local.bindings
  roles    = local.roles
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
| [kubernetes_role_binding.example](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_v1.k8s-rbac](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bindings"></a> [bindings](#input\_bindings) | n/a | <pre>list(object({<br>    group     = string<br>    namespace = string<br>    roles     = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_roles"></a> [roles](#input\_roles) | n/a | <pre>list(object({<br>    actions   = list(string)<br>    resources = list(string)<br><br>  }))</pre> | n/a | yes |

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
| [kubernetes_role_binding.example](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_v1.k8s-rbac](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bindings"></a> [bindings](#input\_bindings) | n/a | <pre>list(object({<br>    group     = string<br>    namespace = string<br>    roles     = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_roles"></a> [roles](#input\_roles) | n/a | <pre>list(object({<br>    actions   = list(string)<br>    resources = list(string)<br><br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

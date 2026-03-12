locals {
  project_roles = try(length(var.project_roles), 0) > 0 ? var.project_roles : ["${var.project_id}=>roles/owner"]
  display_name  = try(length(var.display_name), 0) > 0 ? var.display_name : "terraform created SA"
  description   = try(length(var.description), 0) > 0 ? var.description : "terraform created SA with roles: ${join(",", local.project_roles)}"
}

module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "4.7.0"

  org_id        = var.org_id
  project_id    = var.project_id
  prefix        = var.prefix
  names         = var.names
  project_roles = local.project_roles
  generate_keys = var.generate_keys

  billing_account_id = var.billing_account_id
  grant_billing_role = var.grant_billing_role
  grant_xpn_roles    = var.grant_xpn_roles

  display_name = local.display_name
  description  = local.description
  descriptions = var.descriptions
}


resource "local_file" "keys" {
  count = var.generate_keys && var.pull_keys ? 1 : 0

  content  = length(var.names) > 1 ? jsonencode({ for name, key in module.service_accounts.keys : name => jsondecode(key) }) : module.service_accounts.key
  filename = "${path.cwd}/key${length(var.names) > 1 ? "s" : ""}.json"
}

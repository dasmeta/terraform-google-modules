locals {
  baseline_services = [
    "securitycenter.googleapis.com",
    "securitycentermanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]

  required_services = toset(distinct(concat(local.baseline_services, var.additional_services)))

  normalized_operator_identities = distinct(sort(compact(var.operator_identities)))

  operator_role_bindings = {
    for role in var.operator_roles : role => local.normalized_operator_identities
    if length(local.normalized_operator_identities) > 0
  }

  effective_role_bindings = {
    for role, members in merge(var.baseline_role_bindings, local.operator_role_bindings) :
    role => distinct(sort(compact(members)))
    if length(distinct(sort(compact(members)))) > 0
  }

  project_role_members = merge([
    for role, members in local.effective_role_bindings : {
      for member in members :
      "${role}/${member}" => {
        role   = role
        member = member
      }
    }
  ]...)

  security_signal_filter = coalesce(var.logging_filter, join(" OR ", [
    "protoPayload.serviceName=\"securitycenter.googleapis.com\"",
    "protoPayload.serviceName=\"securitycentermanagement.googleapis.com\"",
  ]))

  monitoring_notification_channels = var.monitoring_integration_enabled && var.monitoring_destination != null ? [var.monitoring_destination] : []
}

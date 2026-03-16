locals {
  required_services = [
    "logging.googleapis.com",
    "securitycenter.googleapis.com",
    "securitycentermanagement.googleapis.com",
  ]

  manual_prerequisites = [
    "Activate SCC Standard for the target project outside Terraform before relying on findings or service-agent behavior.",
  ]

  operator_roles = [
    "roles/securitycenter.admin",
  ]

  unique_operator_identities = distinct(var.operator_identities)

  operator_bindings = {
    for role in local.operator_roles : role => local.unique_operator_identities
    if length(local.unique_operator_identities) > 0
  }

  logging_sink_name = format("%s-scc-findings", var.project_id)

  logging_filter = join(" ", [
    "logName:\"cloudaudit.googleapis.com\"",
    "AND",
    "protoPayload.serviceName=(",
    "\"securitycenter.googleapis.com\"",
    "OR",
    "\"securitycentermanagement.googleapis.com\"",
    ")",
  ])
}

resource "terraform_data" "logging_validation" {
  input = var.logging_destination

  lifecycle {
    precondition {
      condition     = !var.logging_integration_enabled || try(length(trimspace(var.logging_destination)) > 0, false)
      error_message = "logging_destination must be set when logging_integration_enabled is true."
    }
  }
}

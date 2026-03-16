resource "test_assertions" "scc_standard" {
  component = "scc-standard"

  equal "project_id" {
    description = "The module should expose the target project id."
    got         = module.baseline_only.project_id
    want        = "example-project-id"
  }

  equal "manual_activation_required" {
    description = "The module should make the external SCC activation requirement explicit."
    got         = module.baseline_only.manual_activation_required
    want        = true
  }

  equal "required_service_count" {
    description = "The module should expose the configured prerequisite service set."
    got         = length(module.baseline_only.required_services)
    want        = 3
  }

  equal "baseline_only_logging_disabled" {
    description = "The baseline-only example should not create a logging sink."
    got         = module.baseline_only.logging_sink_name
    want        = null
  }

  equal "operator_binding_count" {
    description = "Approved operator identities should be bound to the default SCC operator role."
    got         = length(module.with_integrations.operator_role_bindings["roles/securitycenter.admin"])
    want        = 1
  }

  equal "logging_destination" {
    description = "The configured logging destination should be exposed when integration is enabled."
    got         = module.with_integrations.logging_destination
    want        = "storage.googleapis.com/example-security-bucket"
  }

  equal "logging_sink_name" {
    description = "The logging sink name should be derived deterministically from the project id."
    got         = module.with_integrations.logging_sink_name
    want        = "example-project-id-scc-findings"
  }
}

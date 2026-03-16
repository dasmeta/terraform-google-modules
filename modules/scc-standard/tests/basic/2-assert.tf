check "logging_enabled" {
  assert {
    condition     = module.project_scc_standard.logging_integration_enabled == true
    error_message = "Logging integration should reflect the module input."
  }
}

check "monitoring_enabled" {
  assert {
    condition     = module.project_scc_standard.monitoring_integration_enabled == true
    error_message = "Monitoring integration should reflect the module input."
  }
}

check "operator_identity_count" {
  assert {
    condition     = length(module.project_scc_standard.effective_operator_identities) == 1
    error_message = "The example should normalize one operator identity."
  }
}

check "required_services_include_securitycenter" {
  assert {
    condition     = contains(module.project_scc_standard.required_services, "securitycenter.googleapis.com")
    error_message = "The required services output should include the SCC API."
  }
}

check "logging_filter_mentions_securitycenter" {
  assert {
    condition     = length(regexall("securitycenter.googleapis.com", module.project_scc_standard.logging_export_filter)) > 0
    error_message = "The logging filter should mention the SCC service name."
  }
}

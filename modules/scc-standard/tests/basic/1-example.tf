module "baseline_only" {
  source = "../../"

  project_id = "example-project-id"
}

module "with_integrations" {
  source = "../../"

  project_id = "example-project-id"

  operator_identities = [
    "group:secops@example.com",
  ]

  logging_integration_enabled = true
  logging_destination         = "storage.googleapis.com/example-security-bucket"
}

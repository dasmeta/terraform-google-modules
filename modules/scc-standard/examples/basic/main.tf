module "project_scc_standard" {
  source = "../../"

  project_id = "example-project-id"

  operator_identities = [
    "group:secops@example.com",
  ]

  logging_integration_enabled = true
  logging_destination         = "storage.googleapis.com/example-security-bucket"
}

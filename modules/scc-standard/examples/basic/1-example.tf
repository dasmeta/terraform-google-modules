module "project_scc_standard" {
  source = "../../"

  project_id = "example-project-id"

  operator_identities = [
    "group:secops@example.com",
  ]

  baseline_role_bindings = {
    "roles/logging.viewer" = ["group:auditors@example.com"]
  }

  logging_integration_enabled    = true
  logging_destination            = "storage.googleapis.com/example-security-bucket"
  monitoring_integration_enabled = true
  monitoring_destination         = "projects/example-project-id/notificationChannels/1234567890"
}

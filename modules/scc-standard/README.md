# SCC Standard Project Baseline

This module prepares a Google Cloud project for SCC Standard operations by enabling prerequisite services, managing approved operator IAM, and optionally creating a logging export.

SCC tier activation itself is not automated by this module and must be completed separately.

## Example

```hcl
module "project_scc_standard" {
  source = "dasmeta/modules/google//modules/scc-standard"

  project_id = "example-project-id"

  operator_identities = [
    "group:secops@example.com",
  ]

  logging_integration_enabled = true
  logging_destination         = "storage.googleapis.com/example-security-bucket"
}
```

## Notes

- Required services are enabled additively with `google_project_service`.
- Approved operator IAM is managed additively through `terraform-google-modules/iam/google//modules/projects_iam`.
- Optional logging export is managed through `terraform-google-modules/log-export/google`.
- Monitoring dashboards, alerts, and SCC tier activation remain outside this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

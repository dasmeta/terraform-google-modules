# Quickstart: Project SCC Standard Baseline

## Prerequisites

- Terraform `>= 1.3`
- Access to a Google Cloud project that is eligible for the baseline
- Credentials with permission to enable required services, manage project IAM, and create optional operational integrations
- Any shared logging or monitoring destinations prepared in advance if the optional integrations will be enabled

## 1. Add the module

```hcl
module "project_scc_standard" {
  source = "dasmeta/modules/google//modules/scc-standard"

  project_id = "example-project-id"

  operator_identities = [
    "group:secops@example.com",
  ]

  logging_integration_enabled    = true
  logging_destination            = "storage.googleapis.com/example-security-bucket"
  monitoring_integration_enabled = true
  monitoring_destination         = "projects/example-project-id/notificationChannels/1234567890"
}
```

## 2. Initialize and review

```bash
terraform init
terraform plan
```

Review the plan to confirm:

- required project services will be enabled
- only additive project IAM changes are introduced
- optional integrations match the destinations you intended

## 3. Apply the baseline

```bash
terraform apply
```

## 4. Validate expected results

- The project reaches the documented SCC Standard baseline.
- Required project IAM bindings are present.
- Optional logging and monitoring integrations are created only when enabled.
- Re-running `terraform apply` produces no duplicate bindings or duplicate integrations.

## 5. Run repository-style verification during implementation

```bash
terraform -chdir=modules/scc-standard/tests/basic init
terraform -chdir=modules/scc-standard/tests/basic validate
```

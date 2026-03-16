# Quickstart: Project SCC Standard Baseline

## Prerequisites

- Terraform `>= 1.3`
- A Google Cloud project that is eligible for SCC Standard onboarding
- SCC Standard activated for the target project through the documented Google Cloud console workflow
- Credentials with permission to enable required project services, manage project IAM, and configure optional logging export
- A pre-existing logging destination prepared in advance if logging export will be enabled

## 1. Add the module

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

## 2. Initialize and review

```bash
terraform init
terraform plan
```

Review the plan to confirm:

- required project services will be enabled
- only additive project IAM changes are introduced
- logging export is created only when enabled
- SCC tier activation is documented as external to this module

## 3. Apply the baseline

```bash
terraform apply
```

## 4. Validate expected results

- The project reaches the documented prepared SCC Standard baseline prerequisites.
- Required project IAM bindings are present.
- The logging sink is created only when logging integration is enabled.
- Re-running `terraform apply` does not create duplicate bindings or duplicate logging resources.

## 5. Run repository-style verification during implementation

```bash
terraform -chdir=modules/scc-standard/tests/basic init
terraform -chdir=modules/scc-standard/tests/basic validate
```

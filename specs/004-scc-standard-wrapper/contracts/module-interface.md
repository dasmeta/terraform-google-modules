# Contract: Terraform Module Interface

## Module Name

`modules/scc-standard`

## Required Inputs

- `project_id`: Target Google Cloud project for the baseline.

## Optional Inputs

- `operator_identities`: Additional approved identities that should receive project-level access.
- `logging_integration_enabled`: Enables the logging integration branch.
- `logging_destination`: Logging destination reference used when logging integration is enabled.
- `monitoring_integration_enabled`: Enables the monitoring integration branch.
- `monitoring_destination`: Monitoring destination reference used when monitoring integration is enabled.

## Behavioral Guarantees

- The module converges one project to the documented SCC Standard baseline.
- The module enables required project services before baseline-dependent operations.
- The module adds baseline-required project IAM without taking authoritative control of unrelated IAM bindings.
- The module only creates optional operational integrations when their enablement flags are true.
- The module fails with a clear Terraform error path when required permissions or destinations are missing.

## Expected Outputs

- Baseline status indicators needed by downstream consumers.
- Identifiers for created or connected operational integrations when applicable.
- Useful project-scoped references for validation and documentation.

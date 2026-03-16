# Contract: Terraform Module Interface

## Module Name

`modules/scc-standard`

## Required Inputs

- `project_id`: Target Google Cloud project for the baseline.

## Optional Inputs

- `operator_identities`: Additional approved identities that should receive project-level access.
- `logging_integration_enabled`: Enables the logging export branch.
- `logging_destination`: Destination URI or reference used when logging integration is enabled.

## Derived Internal Inputs

- Required project services for SCC Standard onboarding.
- Baseline-required identities and roles for project-level operation.
- Deterministic sink naming and logging filter values.

## Behavioral Guarantees

- The module prepares one project for the documented SCC Standard baseline within the project privilege boundary.
- The module enables required project services before IAM and logging operations run.
- The module adds approved operator IAM without taking authoritative control of unrelated project bindings.
- The module creates logging export resources only when logging integration is enabled.
- The module documents monitoring dashboards, alerts, and other monitoring artifacts as out of scope for v1.
- The module documents SCC Standard tier activation as an external manual prerequisite.
- The module fails with a clear Terraform error path when required permissions, project prerequisites, or logging destination access are missing.

## Expected Outputs

- Baseline status indicators useful for downstream validation.
- Enabled service identifiers or derived service set output when helpful for verification.
- Logging sink identifiers and writer identity when logging integration is enabled.
- Project-scoped references useful in tests and documentation.

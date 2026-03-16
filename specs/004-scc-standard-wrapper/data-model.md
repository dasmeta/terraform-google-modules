# Data Model: Project SCC Standard Baseline

## Project Security Baseline

**Description**: The desired prepared project-level state converged by one `modules/scc-standard` instance.

**Fields**:

- `project_id`: Target Google Cloud project identifier. Required and unique per module instance.
- `security_tier`: Baseline tier documented by this module version. Fixed to `standard` for v1.
- `required_services`: Set of project APIs that must be enabled before SCC baseline resources and integrations can converge.
- `baseline_activation_required`: Boolean flag indicating that SCC tier activation remains external to the module.
- `operator_identities`: Optional set of additional caller-supplied identities that receive approved operator roles.
- `logging_integration_enabled`: Boolean flag controlling whether the logging export branch is active.
- `logging_destination`: Destination URI or reference used by the logging export path when enabled.
- `logging_sink_name`: Derived sink name created or managed by the logging integration branch.
- `status`: Derived convergence state for the baseline instance.

**Relationships**:

- Owns one `Onboarding Request`.
- Owns one `Required Service Set`.
- Owns zero or more `Approved Identity` records.
- Owns zero or one `Logging Integration`.

**Validation Rules**:

- `project_id` must be provided.
- `logging_destination` must be provided when `logging_integration_enabled` is `true`.
- `operator_identities` may be empty, but `baseline_identities` may not be empty once the module resolves required principals.

**State Transitions**:

- `requested` -> `services_enabled`
- `services_enabled` -> `access_assigned`
- `access_assigned` -> `logging_connected`
- `logging_connected` -> `converged`
- `access_assigned` -> `converged` when logging integration is disabled
- Any state -> `failed` when required permissions, project services, or logging destination access are unavailable

## Onboarding Request

**Description**: The user-supplied input set for one module instance.

**Fields**:

- `project_id`
- `operator_identities`
- `logging_integration_enabled`
- `logging_destination`

**Relationships**:

- Produces one `Project Security Baseline`.

**Validation Rules**:

- `project_id` is required.
- `logging_destination` is conditionally required when logging integration is enabled.

## Approved Identity

**Description**: A principal that receives approved project-level access from the module.

**Fields**:

- `member`: Canonical IAM member string.
- `purpose`: Fixed to `operator` in v1.
- `required_roles`: Set of project roles assigned by the module.
- `optional`: Boolean flag identifying caller-supplied operator identities.

**Relationships**:

- Belongs to one `Project Security Baseline`.

**Validation Rules**:

- `member` must be unique within the module instance.
- `required_roles` must not be empty.

## Required Service Set

**Description**: The project services that must be enabled before baseline convergence.

**Fields**:

- `services`: Set of service APIs enabled by direct `google_project_service` resources.
- `enforcement_mode`: Fixed to additive enablement; the module enables required services but does not disable unrelated ones.

**Relationships**:

- Belongs to one `Project Security Baseline`.

**Validation Rules**:

- `services` must contain the full minimum set documented by the module for SCC Standard onboarding.

## Logging Integration

**Description**: The optional log-export branch that forwards SCC-relevant signals to a caller-supplied destination.

**Fields**:

- `enabled`: Boolean flag derived from module input.
- `destination`: Destination URI or reference for the sink target.
- `filter`: Derived logging filter used for SCC-relevant signals.
- `sink_name`: Deterministic sink identifier exposed by module outputs.
- `writer_identity`: Derived service identity used by the sink when applicable.

**Relationships**:

- Belongs to one `Project Security Baseline`.

**Validation Rules**:

- `destination` is required when `enabled` is `true`.
- `sink_name` must be deterministic for idempotent re-apply behavior.

## Scale Assumptions

- One module instance manages one project.
- Many projects may reuse the module independently.
- The common case is a single logging destination and a small list of operator identities.

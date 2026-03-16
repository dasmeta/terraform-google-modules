# Data Model: Project SCC Standard Baseline

## Project Security Baseline

**Description**: The desired project-level security state applied by the module.

**Fields**:

- `project_id`: Target Google Cloud project identifier. Required and unique per module instance.
- `security_tier`: Expected baseline tier for the module version. Initial value is SCC Standard.
- `required_services`: Set of Google Cloud services that must be enabled before the baseline can operate.
- `service_identities`: Set of Google-managed or caller-provided identities that require baseline access.
- `operator_identities`: Optional set of approved administrator identities receiving project access.
- `logging_integration_enabled`: Boolean flag controlling logging integration behavior.
- `monitoring_integration_enabled`: Boolean flag controlling monitoring integration behavior.
- `logging_destination`: Optional operational destination used when logging integration is enabled.
- `monitoring_destination`: Optional operational destination used when monitoring integration is enabled.
- `status`: Derived convergence state for the target project.

**Relationships**:

- Owns zero or more `Approved Identity` records.
- Owns zero, one, or two `Operational Destination` records.
- Is created from exactly one `Onboarding Request`.

**Validation Rules**:

- `project_id` must be provided.
- Logging destination must be present when logging integration is enabled.
- Monitoring destination must be present when monitoring integration is enabled.
- Optional operator identities may be empty, but baseline-required identities may not.

**State Transitions**:

- `requested` -> `prerequisites_enabled`
- `prerequisites_enabled` -> `access_assigned`
- `access_assigned` -> `integrations_connected`
- `integrations_connected` -> `converged`
- Any state -> `failed` when required permissions, services, or destinations are unavailable

## Approved Identity

**Description**: A principal that needs baseline-related project access.

**Fields**:

- `member`: Canonical IAM member string.
- `purpose`: Baseline service operation or human administration.
- `required_roles`: Set of project roles assigned by the module.
- `optional`: Boolean flag indicating whether the identity is user-supplied or baseline-required.

**Relationships**:

- Belongs to one `Project Security Baseline`.

**Validation Rules**:

- `member` must be unique within the module instance.
- `required_roles` must not be empty for active identities.

## Operational Destination

**Description**: A logging or monitoring target used for security signal visibility.

**Fields**:

- `type`: Logging or monitoring.
- `destination_id`: Destination reference supplied by the caller or derived from a composed module.
- `enabled`: Boolean flag determining whether the branch is active.
- `access_requirements`: Set of permissions required for the integration to succeed.

**Relationships**:

- Belongs to one `Project Security Baseline`.

**Validation Rules**:

- `destination_id` is required when `enabled` is true.
- Each baseline can have at most one destination per `type`.

## Onboarding Request

**Description**: The user-supplied inputs that drive one module instance.

**Fields**:

- `project_id`
- `operator_identities`
- `logging_integration_enabled`
- `logging_destination`
- `monitoring_integration_enabled`
- `monitoring_destination`

**Relationships**:

- Produces one `Project Security Baseline`.

**Scale Assumptions**:

- One request targets one project.
- The module is expected to be reused across many projects, but each instance converges independently.

# Phase 0 Research: Project SCC Standard Baseline

## Decision 1: Use a composed wrapper, not a single upstream SCC module

**Decision**: Build the new module as a focused wrapper that composes public Google Terraform modules only for the parts they fit well, rather than trying to anchor the design on one upstream SCC module.

**Rationale**: Current provider-maintained Google module candidates cover adjacent concerns, not the requested project-level SCC Standard baseline as a whole. `project-factory` is broader than this use case, `projects_iam` fits additive IAM well, and `log-export` fits project-level log sinks, but no provider-maintained SCC Standard project module was identified.

**Alternatives considered**:

- Use `project-factory` as the main wrapper baseline: rejected because it is optimized for project creation/bootstrap and would add broader lifecycle responsibilities than the spec requires.
- Implement everything with direct provider resources and no public module composition: rejected because additive IAM and log export already have stable public module patterns worth reusing.

## Decision 2: Keep v1 at project scope and fail closed on organization prerequisites

**Decision**: Treat the module as a project-scoped baseline only. If a requested behavior requires organization-level SCC administration or shared prerequisite setup outside the project boundary, the module should document that prerequisite and fail clearly instead of trying to manage it implicitly.

**Rationale**: The spec and repository standards both favor a coherent responsibility and a single privilege boundary. A project-scoped module should not silently take ownership of organization-wide SCC administration.

**Alternatives considered**:

- Expand the module to manage organization-level SCC state: rejected because it crosses privilege boundaries and materially broadens the module scope.
- Ignore organization prerequisites and claim project-only success anyway: rejected because that would hide real operational dependencies and produce misleading automation.

## Decision 3: Use additive IAM behavior for operator access

**Decision**: Manage project IAM in additive mode wherever public IAM modules support it.

**Rationale**: The feature needs to add required baseline access without taking authoritative control of unrelated project IAM bindings. Additive behavior best matches the spec’s requirement to avoid surprising project-wide permission changes.

**Alternatives considered**:

- Use authoritative IAM bindings: rejected because it creates a higher risk of removing unrelated access and does not fit the requested baseline behavior.
- Manage all IAM bindings with raw provider resources only: rejected because the public IAM module already handles additive project IAM cleanly.

## Decision 4: Treat logging and monitoring integrations as optional module branches

**Decision**: Design logging and monitoring integration as optional, independently switchable branches of the baseline, with clear failure behavior when a configured destination is missing or inaccessible.

**Rationale**: The feature spec explicitly makes operational integrations optional while baseline security enablement remains mandatory. This also keeps the common case simple for projects that only need onboarding.

**Alternatives considered**:

- Make both integrations mandatory: rejected because it conflicts with the accepted spec assumptions.
- Defer all integrations to follow-up modules: rejected because the feature explicitly includes them as part of the baseline wrapper.

## Decision 5: Align test coverage to repository-native Terraform example tests

**Decision**: Validate the module with repository-native Terraform example tests using `0-setup.tf`, `1-example.tf`, and `2-assert.tf`, plus `terraform validate` and documentation consistency checks.

**Rationale**: This matches the internal standard and the existing structure used in `modules/uptime-check`.

**Alternatives considered**:

- Skip tests initially and rely on manual examples: rejected because the module interface and optional integrations are substantial enough to require repeatable verification.
- Introduce a new test harness: rejected because the repository already has a preferred test shape.

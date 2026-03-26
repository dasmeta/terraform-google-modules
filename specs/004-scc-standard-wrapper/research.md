# Phase 0 Research: Project SCC Standard Baseline

## Decision 1: Use a focused wrapper with selective public-module composition

**Decision**: Build `modules/scc-standard` as a narrow project-scoped wrapper that composes public Google modules only where they cleanly match the need, and keep unsupported SCC tier-activation behavior out of Terraform automation.

**Rationale**: The clarified spec requires public Google modules to be wrapped where useful, but not at the cost of pulling in broader project lifecycle behavior. `projects_iam` and `log-export` fit the interface, while project-level SCC tier activation currently remains outside safe Terraform coverage and should stay explicit in documentation.

**Alternatives considered**:

- Wrap a broader upstream project module as the baseline: rejected because it expands ownership beyond the project-scoped SCC baseline.
- Use only direct provider resources: rejected because additive IAM and log export already have stable public module patterns worth reusing.

## Decision 2: Enable required services directly instead of wrapping `project-factory`

**Decision**: Manage required API activation with direct `google_project_service` resources rather than composing `terraform-google-modules/project-factory/google`.

**Rationale**: `project-factory` is optimized for project bootstrap and lifecycle management, which is broader than this feature. Direct service-enablement resources keep the module focused on an existing-project baseline and make dependency ordering explicit.

**Alternatives considered**:

- Use `project-factory` only for API activation patterns: rejected because the surrounding module contract and lifecycle assumptions are still broader than needed.
- Require services to be pre-enabled outside the module: rejected because the spec requires the module to converge prerequisites during onboarding.

## Decision 3: Keep the module strictly project-scoped and fail closed on organization prerequisites

**Decision**: Treat organization-level SCC readiness and project-level SCC tier activation as external prerequisites. If project-level application reveals missing organization authority, the module should fail clearly and document that boundary instead of trying to activate SCC.

**Rationale**: The repository standards require a coherent responsibility and a single privilege boundary. Expanding into organization administration would materially change both permissions and module scope.

**Alternatives considered**:

- Extend the module to manage organization-level SCC state: rejected because it crosses privilege boundaries and broadens the module beyond the approved scope.
- Ignore organization prerequisites and claim success based only on local resources: rejected because that would misrepresent the actual security baseline state.

## Decision 4: Treat operator IAM as the managed IAM scope for v1

**Decision**: Manage additive project IAM for approved operator identities in v1, and document that SCC service agents created during manual activation remain outside this module’s responsibility.

**Rationale**: Manual SCC activation creates or updates service-agent state outside Terraform. Keeping IAM scope focused on approved operator access avoids pretending to manage identities that the module cannot safely create itself.

**Alternatives considered**:

- Attempt to manage SCC-created service agents directly: rejected because those identities depend on external activation and may not exist at plan time.
- Remove IAM from the module entirely: rejected because approved operator access remains part of the requested baseline.
## Decision 5: Use additive IAM for approved operator identities

**Decision**: Compose `terraform-google-modules/iam/google//modules/projects_iam` in additive mode for project-level operator role assignment.

**Rationale**: The spec requires baseline access to be granted without taking ownership of unrelated IAM bindings. Additive behavior fits that requirement and aligns with the public module’s strengths.

**Alternatives considered**:

- Use authoritative project IAM bindings: rejected because that risks removing unrelated access.
- Rebuild additive IAM behavior with raw resources only: rejected because the public IAM module already encapsulates the common case.

## Decision 6: Limit v1 downstream integration to logging export

**Decision**: Manage only logging export in v1 and explicitly leave monitoring dashboards, alerts, and other monitoring artifacts out of scope.

**Rationale**: The clarification narrowed the operational integration scope to logging export only. This keeps the module interface testable and avoids inventing a vague “monitoring destination” abstraction.

**Alternatives considered**:

- Support both logging and monitoring in v1: rejected because the accepted clarification explicitly removed monitoring artifacts from scope.
- Defer all downstream integrations: rejected because logging export remains part of the approved baseline.

## Decision 7: Use repository-native Terraform example tests and aligned docs

**Decision**: Validate the module with repository-native Terraform tests under `tests/basic/` using `0-setup.tf`, `1-example.tf`, and `2-assert.tf`, and keep `README.md` plus `examples/basic/` aligned with the same interface.

**Rationale**: This matches the repository’s established Terraform-module testing shape and the internal standards that require docs, examples, and tests to evolve together.

**Alternatives considered**:

- Add only a README example initially: rejected because the module needs repeatable verification for idempotency and optional logging behavior.
- Introduce a new test harness: rejected because the repository already has a native Terraform example-test pattern.

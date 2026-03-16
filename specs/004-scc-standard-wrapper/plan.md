# Implementation Plan: Project SCC Standard Baseline

**Branch**: `004-scc-standard-wrapper` | **Date**: 2026-03-16 | **Spec**: [/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/specs/004-scc-standard-wrapper/spec.md](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/specs/004-scc-standard-wrapper/spec.md)
**Input**: Feature specification from `/specs/004-scc-standard-wrapper/spec.md`

**Note**: This plan covers Phase 0 research and Phase 1 design artifacts for a new Terraform wrapper module under `modules/`.

## Summary

Create a new project-scoped Terraform module that establishes a repeatable Security Command Center Standard baseline for one Google Cloud project at a time. The implementation should prefer existing public `terraform-google-modules` building blocks where they fit cleanly for API enablement, additive IAM, and operational integrations, and fall back to direct Google provider resources only where no suitable upstream wrapper exists.

## Technical Context

**Language/Version**: Terraform `>= 1.3`  
**Primary Dependencies**: HashiCorp Google provider, optional Google Beta provider, `terraform-google-modules/project-factory/google` for API activation patterns, `terraform-google-modules/iam/google//modules/projects_iam`, `terraform-google-modules/log-export/google`  
**Storage**: Terraform state only  
**Testing**: Terraform example tests with `0-setup.tf`, `1-example.tf`, `2-assert.tf`; `terraform validate`; repository documentation generation flow  
**Target Platform**: Google Cloud project-level module execution from local or CI runners  
**Project Type**: Terraform module  
**Performance Goals**: One apply path should onboard a single eligible project without manual post-configuration and repeated applies should converge without duplicate bindings or integrations  
**Constraints**: Must stay within project scope, use additive IAM semantics where possible, document any direct-provider fallback explicitly, and keep README/examples/tests aligned with the live interface  
**Scale/Scope**: One reusable module for many projects; initial release targets the common project-level SCC Standard baseline plus optional logging and monitoring integrations

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Authority chain loaded: `.specify/memory/constitution.md` -> [docs/terraform-module-authority.md](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/docs/terraform-module-authority.md) -> installed `terraform-module-developer` skill and bundled references.
- Repository scope check: planned changes are limited to a new module directory under `modules/`, feature spec artifacts under `specs/004-scc-standard-wrapper/`, and agent context metadata. No broader repository expansion is required.
- Upstream wrapper check: provider-maintained Google modules were evaluated first. The closest reusable building blocks are `project-factory` for API/service activation patterns, `iam` for additive project IAM, and `log-export` for logging sinks. No provider-maintained module appears to offer a dedicated SCC Standard project wrapper, so direct provider resources remain necessary for SCC-specific behavior.
- Conflict check: no current module is being modified, so there is no standards conflict with an existing implementation.
- Breaking change check: none, because this is a new module.
- Gate result: PASS for Phase 0 research.

## Project Structure

### Documentation (this feature)

```text
specs/004-scc-standard-wrapper/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── module-interface.md
│   └── acceptance-scenarios.md
└── tasks.md
```

### Source Code (repository root)

```text
modules/
├── scc-standard/
│   ├── README.md
│   ├── main.tf
│   ├── apis.tf
│   ├── iam.tf
│   ├── integrations.tf
│   ├── locals.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── versions.tf
│   ├── examples/
│   │   └── basic/
│   │       ├── 0-setup.tf
│   │       ├── 1-example.tf
│   │       └── README.md
│   └── tests/
│       └── basic/
│           ├── 0-setup.tf
│           ├── 1-example.tf
│           ├── 2-assert.tf
│           └── README.md
└── [existing modules unchanged]
```

**Structure Decision**: Use a new focused module under `modules/scc-standard/`. Split Terraform files by responsibility to keep API enablement, IAM, and operational integrations readable, while matching the repository’s existing examples/tests layout.

## Complexity Tracking

No constitution violations or justified exceptions are currently required.

## Phase 0: Research Plan

### Current Repository Module State

- Existing modules show a lightweight pattern: focused module directories under `modules/`, Terraform resources split by responsibility when useful, README-driven usage, and Terraform-based example or test directories.
- Existing coverage is uneven: some modules have `versions.tf` and outputs, some do not. For this new module, the internal baseline requires explicit `providers.tf`, `versions.tf`, README, examples, and tests.
- No existing SCC module or closely related security baseline module exists in this repository.

### Gaps Versus Internal Standards

- New module must include the standard file set up front instead of inheriting the uneven coverage seen in older modules.
- Variables and outputs need explicit descriptions and minimal interface exposure.
- Tests should follow the preferred `0-setup.tf`, `1-example.tf`, `2-assert.tf` pattern.
- The plan must document provider expectations and wrapper rationale explicitly.

### Candidate Upstream Modules Considered

- `terraform-google-modules/terraform-google-project-factory`: useful for service activation and project bootstrap patterns, but too broad as a wrapper baseline because it creates and manages whole projects.
- `terraform-google-modules/terraform-google-iam//modules/projects_iam`: suitable for additive project IAM role assignment.
- `terraform-google-modules/terraform-google-log-export`: suitable for project-level logging export integration.
- No provider-maintained `terraform-google-modules` package was identified for project-level SCC Standard enablement itself.

### Chosen Wrapper Baseline and Fallback Rationale

- Wrapper baseline: compose selected public modules for additive IAM and log export where those modules reduce custom code cleanly.
- Direct-provider fallback: use Google provider resources for SCC-specific baseline steps because no provider-maintained SCC Standard project wrapper was found.
- Fallback is justified because the requested capability is narrower than `project-factory` and more project-scoped than the official SCC Terraform coverage currently exposed for organization and folder notification/export resources.

### Research Tasks and Decisions

1. Confirm the closest reusable upstream module set for project API enablement, IAM, and logging export.
2. Confirm the provider coverage boundary for SCC-specific resources so the module does not promise unsupported project-level automation.
3. Define the common-case module scope boundary for v1 to avoid organization-level or premium-tier feature creep.
4. Define a documentation and test strategy consistent with the repository’s module patterns.

## Phase 1: Design Plan

### Data Model Direction

- Model the feature around a single `Project Security Baseline` aggregate with nested API activation, IAM assignments, and optional operational integrations.
- Treat approved identities and operational destinations as explicit user-provided inputs with validation and conditional creation behavior.
- Represent onboarding success as converged project state rather than a long-running workflow or external datastore.

### Contract Direction

- Document the Terraform module interface as the contract users interact with: required inputs, optional inputs, outputs, and guaranteed behaviors.
- Document acceptance scenarios separately so implementation and tests can trace back to spec commitments without reading Terraform internals.

### Planned File Changes

- Create [modules/scc-standard/README.md](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/README.md)
- Create [modules/scc-standard/main.tf](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/main.tf)
- Create [modules/scc-standard/apis.tf](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/apis.tf)
- Create [modules/scc-standard/iam.tf](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/iam.tf)
- Create [modules/scc-standard/integrations.tf](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/integrations.tf)
- Create [modules/scc-standard/locals.tf](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/locals.tf)
- Create [modules/scc-standard/variables.tf](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/variables.tf)
- Create [modules/scc-standard/outputs.tf](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/outputs.tf)
- Create [modules/scc-standard/providers.tf](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/providers.tf)
- Create [modules/scc-standard/versions.tf](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/versions.tf)
- Create example and test files under [modules/scc-standard/examples/basic/](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/examples/basic) and [modules/scc-standard/tests/basic/](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic)
- Update [AGENTS.md](/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/AGENTS.md) via the agent context script

### Potential Breaking Changes

- None for the repository interface, because this is a new module addition.

### Conflicts Requiring Approval

- None at planning time. If implementation reveals that project-level SCC Standard activation requires organization-level setup that cannot be modeled safely inside a project-scoped module, that becomes a scope conflict and must stop for user approval.

## Phase 2: Implementation Planning Direction

- Keep the first version narrow: one project at a time, additive IAM, optional integrations, and no organization-wide SCC administration.
- Prefer public module composition only where it reduces complexity; do not wrap `project-factory` wholesale for an existing-project use case.
- Build documentation and example/test coverage alongside the module, not after.

## Post-Design Constitution Check

- Authority chain preserved after design: PASS.
- Project scope remains limited to a single coherent privilege boundary: PASS.
- Wrapper-first evaluation documented before fallback to direct resources: PASS.
- Required file coverage includes README, examples, tests, providers, and versions: PASS.
- No breaking changes or approval-gated conflicts introduced in the design artifacts: PASS.

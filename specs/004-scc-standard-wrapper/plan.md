# Implementation Plan: Project SCC Standard Baseline

**Branch**: `004-scc-standard-wrapper` | **Date**: 2026-03-16 | **Spec**: [/Users/aram.karapetzan/Development/dasmeta/terraform/terraform-google-modules/specs/004-scc-standard-wrapper/spec.md](/Users/aram.karapetzan/Development/dasmeta/terraform/terraform-google-modules/specs/004-scc-standard-wrapper/spec.md)
**Input**: Feature specification from `/specs/004-scc-standard-wrapper/spec.md`

**Note**: This plan covers Phase 0 research and Phase 1 design outputs for a new Terraform module under `modules/scc-standard`. Implementation tasks are deferred to `/speckit.tasks`.

## Summary

Create a new project-scoped Terraform wrapper module at `modules/scc-standard` that prepares one Google Cloud project for the SCC Standard baseline. The module should stay within the project privilege boundary, compose public `terraform-google-modules` components where they fit cleanly for additive IAM and log export, manage required service enablement directly, and document SCC tier activation as an external manual prerequisite.

## Technical Context

**Language/Version**: Terraform `>= 1.3`  
**Primary Dependencies**: HashiCorp Google provider, optional HashiCorp Google Beta provider, direct `google_project_service` resources for required API activation, `terraform-google-modules/iam/google//modules/projects_iam` for additive IAM, `terraform-google-modules/log-export/google` for optional logging sink integration  
**Storage**: Terraform state only  
**Testing**: Repository-native Terraform example tests (`0-setup.tf`, `1-example.tf`, `2-assert.tf`), `terraform validate`, and repository CI checks (`tflint`, `tfsec`, `checkov`)  
**Target Platform**: Google Cloud project-scoped Terraform module executed from local developer machines and CI  
**Project Type**: Terraform module  
**Performance Goals**: One deterministic baseline-preparation path for eligible projects and idempotent re-apply behavior with no duplicate IAM or logging resources  
**Constraints**: One project per module instance; project-level scope only; fail closed when organization-level SCC prerequisites are missing; logging export is the only managed downstream integration in v1; SCC tier activation is external to the module; public modules are used selectively rather than wrapped wholesale  
**Scale/Scope**: One reusable module consumed across many projects; first release covers prerequisite enablement, additive IAM, and optional logging export

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Authority chain loaded and satisfied:
  - `.specify/memory/constitution.md`
  - `docs/terraform-module-authority.md`
  - `.codex/constitution/skills/terraform-module-developer/SKILL.md` and bundled references
- Repository scope check: PASS. Work is confined to a new module in this repository plus aligned docs/examples/tests and feature-spec artifacts.
- Standards alignment check: PASS. Planned file coverage includes `README.md`, `examples/`, `tests/`, `versions.tf`, `providers.tf`, `variables.tf`, `outputs.tf`, and responsibility-scoped Terraform files.
- Privilege-boundary check: PASS. The design stays project-scoped and treats organization-level readiness and SCC tier activation as external requirements with explicit documentation.
- Upstream template usage check: PASS with note. Upstream scratch-template guidance was consulted only for new-module coverage expectations; no wholesale template copy is planned.
- Blocking conflicts: none identified at planning time.

## Project Structure

### Documentation (this feature)

```text
specs/004-scc-standard-wrapper/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── acceptance-scenarios.md
│   └── module-interface.md
└── tasks.md
```

### Source Code (repository root)

```text
modules/
└── scc-standard/
    ├── README.md
    ├── main.tf
    ├── services.tf
    ├── iam.tf
    ├── logging.tf
    ├── locals.tf
    ├── variables.tf
    ├── outputs.tf
    ├── versions.tf
    ├── providers.tf
    ├── examples/
    │   └── basic/
    │       ├── main.tf
    │       └── README.md
    └── tests/
        └── basic/
            ├── 0-setup.tf
            ├── 1-example.tf
            ├── 2-assert.tf
            └── README.md
```

**Structure Decision**: Create a focused module directory under `modules/scc-standard` and split Terraform files by responsibility instead of hiding all behavior in `main.tf`. Keep `main.tf` for top-level orchestration and module composition, with dedicated files for service activation, IAM, and logging so the public-module boundaries remain visible and testable.

## Phase 0: Research Plan

Research resolves the following planning decisions before implementation tasks are written:

1. Which public Google modules fit this project-scoped wrapper cleanly, and which concerns should remain explicit local resources or documentation.
2. How to keep the module inside the project privilege boundary when SCC readiness depends on organization-level state and manual activation.
3. Which IAM pattern preserves additive behavior for required and optional identities.
4. What the v1 logging-only integration contract should look like.
5. Which repository-native test shape should validate the module.

Phase 0 output is recorded in `research.md`.

## Phase 1: Design Outputs

Phase 1 translates the approved spec and research decisions into implementation-facing design artifacts:

- `data-model.md`: defines the prepared project baseline, onboarding request, approved identities, required service set, and logging integration model.
- `contracts/module-interface.md`: defines the Terraform module inputs, outputs, and behavioral guarantees.
- `contracts/acceptance-scenarios.md`: defines the feature-level acceptance behaviors that tests and examples must cover.
- `quickstart.md`: defines a minimal consumer flow for using the future module.

## Phase 2: Implementation Planning Direction

`/speckit.tasks` should decompose implementation around these workstreams:

1. Scaffold `modules/scc-standard` with explicit provider/version files, documented variables, useful outputs, and responsibility-scoped Terraform files.
2. Implement required service activation and external-prerequisite documentation with clear dependency ordering and fail-closed behavior.
3. Compose additive IAM via the public IAM module for baseline-required and optional operator identities.
4. Compose optional logging export via the public log-export module and expose useful sink outputs.
5. Add README, example usage, and repository-native tests covering baseline-only, IAM, logging-enabled, and failure/idempotency paths.

## Post-Design Constitution Check

- Authority chain still satisfied after design: PASS.
- Module remains within one coherent responsibility and one privilege boundary: PASS.
- Planned interface remains narrow and common-case focused: PASS.
- Documentation, examples, tests, provider/version files remain part of the design scope: PASS.
- No constitution violations or approval-gated conflicts introduced by Phase 1 artifacts: PASS.

## Complexity Tracking

No constitution violations requiring justification.

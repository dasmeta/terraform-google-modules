# Tasks: Project SCC Standard Baseline

**Input**: Design documents from `/specs/004-scc-standard-wrapper/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Include Terraform example and integration-style validation tasks because the feature spec requires independently testable user stories and the plan defines repository-native Terraform tests.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (`US1`, `US2`, `US3`)
- Include exact file paths in descriptions

## Path Conventions

- Terraform module root: `modules/scc-standard/`
- Example usage: `modules/scc-standard/examples/basic/`
- Verification tests: `modules/scc-standard/tests/basic/`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the new module skeleton and shared repository-facing scaffolding.

- [X] T001 Create the module directory structure in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/`, `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/examples/basic/`, and `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/`
- [X] T002 [P] Create provider and version constraints in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/providers.tf` and `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/versions.tf`
- [X] T003 [P] Create shared local values and interface placeholders in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/locals.tf`, `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/variables.tf`, and `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/outputs.tf`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build the core module frame and common validation logic that every user story depends on.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T004 Create the root module orchestration in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/main.tf`
- [X] T005 [P] Implement shared input validation and canonical baseline locals in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/locals.tf`
- [X] T006 [P] Author the initial module contract and usage documentation in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/README.md`
- [X] T007 Create the common example provider bootstrap in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/examples/basic/0-setup.tf`
- [X] T008 Create the common test provider bootstrap in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/0-setup.tf`

**Checkpoint**: Foundation ready. User story implementation can now proceed.

---

## Phase 3: User Story 1 - Enable a project security baseline (Priority: P1) 🎯 MVP

**Goal**: Enable SCC Standard prerequisites and baseline convergence for one project.

**Independent Test**: Apply the module for a project with required inputs only and confirm required services are enabled, SCC baseline resources converge, and re-apply does not require manual cleanup.

### Tests for User Story 1

- [X] T009 [P] [US1] Create baseline convergence example in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/examples/basic/1-example.tf`
- [X] T010 [P] [US1] Create baseline verification assertions in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/1-example.tf` and `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/2-assert.tf`

### Implementation for User Story 1

- [X] T011 [P] [US1] Implement required API enablement logic in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/apis.tf`
- [X] T012 [P] [US1] Implement SCC baseline resource logic and dependency wiring in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/main.tf`
- [X] T013 [US1] Extend module inputs, outputs, and documentation for baseline onboarding in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/variables.tf`, `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/outputs.tf`, and `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/README.md`
- [X] T014 [US1] Add example and test README guidance for baseline-only onboarding in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/examples/basic/README.md` and `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/README.md`

**Checkpoint**: User Story 1 is independently functional and is the MVP scope.

---

## Phase 4: User Story 2 - Grant the required access safely (Priority: P2)

**Goal**: Add baseline-required project access and optional operator identities without taking authoritative control of unrelated IAM.

**Independent Test**: Apply the module with baseline-required and optional operator identities, then verify additive IAM bindings are created while unrelated project bindings remain unchanged.

### Tests for User Story 2

- [X] T015 [P] [US2] Extend the example to cover optional operator identities in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/examples/basic/1-example.tf`
- [X] T016 [P] [US2] Add additive IAM assertions in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/2-assert.tf`

### Implementation for User Story 2

- [X] T017 [P] [US2] Implement additive IAM composition and role mapping in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/iam.tf`
- [X] T018 [P] [US2] Extend identity normalization and optional-admin logic in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/locals.tf`
- [X] T019 [US2] Update module inputs, outputs, and README for operator identity management in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/variables.tf`, `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/outputs.tf`, and `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/README.md`

**Checkpoint**: User Stories 1 and 2 both work, and US2 remains independently testable through additive IAM behavior.

---

## Phase 5: User Story 3 - Connect security signals to operations (Priority: P3)

**Goal**: Add optional logging and monitoring integration branches for operational visibility.

**Independent Test**: Apply the module with integration flags enabled and valid destinations to verify integration resources are connected; apply again with integrations disabled and verify baseline onboarding still succeeds without those resources.

### Tests for User Story 3

- [X] T020 [P] [US3] Extend the example with logging and monitoring destinations in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/examples/basic/1-example.tf`
- [X] T021 [P] [US3] Add enabled and disabled integration assertions in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/2-assert.tf`

### Implementation for User Story 3

- [X] T022 [P] [US3] Implement optional logging and monitoring integration resources in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/integrations.tf`
- [X] T023 [P] [US3] Extend conditional integration locals and validation rules in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/locals.tf`
- [X] T024 [US3] Update module inputs, outputs, and README for operational integrations in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/variables.tf`, `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/outputs.tf`, and `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/README.md`

**Checkpoint**: All user stories are independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency, documentation, and repo-style verification across all stories.

- [X] T025 [P] Regenerate Terraform documentation and align rendered module docs in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/README.md`
- [X] T026 [P] Run formatting and validation for the module in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/`
- [X] T027 Run repository-style example test verification in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/`
- [X] T028 Review quickstart alignment and finalize feature docs in `/Users/vazgen/work/Dasmeta/modules/terraform-google-modules/specs/004-scc-standard-wrapper/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup completion and blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational completion.
- **User Story 2 (Phase 4)**: Depends on Foundational completion and should be implemented after US1 because it extends the same module interface.
- **User Story 3 (Phase 5)**: Depends on Foundational completion and should be implemented after US1 because it extends the same module interface.
- **Polish (Phase 6)**: Depends on completion of all selected user stories.

### User Story Dependencies

- **US1**: No story dependency beyond the foundation; this is the MVP.
- **US2**: Reuses the baseline module surface created in US1 but remains independently testable once merged.
- **US3**: Reuses the baseline module surface created in US1 but remains independently testable once merged.

### Dependency Graph

```text
Setup -> Foundational -> US1 -> Polish
                    -> US2 -^
                    -> US3 -^
```

### Within Each User Story

- Example/test tasks precede the main story implementation.
- Terraform resource files and locals can be developed in parallel when they do not modify the same file.
- Variable/output/README consolidation follows core implementation for that story.

### Parallel Opportunities

- `T002` and `T003`
- `T005` and `T006`
- `T009` and `T010`
- `T011` and `T012`
- `T015` and `T016`
- `T017` and `T018`
- `T020` and `T021`
- `T022` and `T023`
- `T025` and `T026`

---

## Parallel Example: User Story 1

```bash
Task: "Create baseline convergence example in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/examples/basic/1-example.tf"
Task: "Create baseline verification assertions in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/1-example.tf and /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/2-assert.tf"

Task: "Implement required API enablement logic in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/apis.tf"
Task: "Implement SCC baseline resource logic and dependency wiring in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/main.tf"
```

## Parallel Example: User Story 2

```bash
Task: "Extend the example to cover optional operator identities in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/examples/basic/1-example.tf"
Task: "Add additive IAM assertions in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/2-assert.tf"

Task: "Implement additive IAM composition and role mapping in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/iam.tf"
Task: "Extend identity normalization and optional-admin logic in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/locals.tf"
```

## Parallel Example: User Story 3

```bash
Task: "Extend the example with logging and monitoring destinations in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/examples/basic/1-example.tf"
Task: "Add enabled and disabled integration assertions in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/tests/basic/2-assert.tf"

Task: "Implement optional logging and monitoring integration resources in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/integrations.tf"
Task: "Extend conditional integration locals and validation rules in /Users/vazgen/work/Dasmeta/modules/terraform-google-modules/modules/scc-standard/locals.tf"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Validate the module through the basic example and test configuration.
5. Stop for review before layering IAM and operational integrations.

### Incremental Delivery

1. Deliver baseline onboarding in US1.
2. Add additive IAM behavior in US2 without broadening module scope.
3. Add optional operational integrations in US3.
4. Finish with repository-style documentation and validation tasks.

### Parallel Team Strategy

1. One engineer completes Setup and Foundational tasks.
2. After the foundation is stable, one engineer can drive IAM (`US2`) while another drives integrations (`US3`), with coordination on shared files such as `variables.tf`, `outputs.tf`, and `README.md`.

---

## Notes

- Every task uses the required checklist format with an ID, optional `[P]`, and `[US#]` labels only in story phases.
- User story tasks are organized so each story has its own test criteria and implementation path.
- Shared-file updates are intentionally sequenced after parallelizable resource work to reduce merge conflicts.
- MVP scope is Phase 3 only: baseline onboarding for one project.

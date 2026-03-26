# Tasks: Project SCC Standard Baseline

**Input**: Design documents from `/specs/004-scc-standard-wrapper/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Include repository-native Terraform example tests because the specification requires each user story to be independently testable.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel when dependencies are already complete and files do not overlap
- **[Story]**: Which user story this task belongs to (`[US1]`, `[US2]`, `[US3]`)
- Every task includes an exact file path

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the new module skeleton and baseline repository-facing files.

- [X] T001 Create the module directory structure for `modules/scc-standard/`, `modules/scc-standard/examples/basic/`, and `modules/scc-standard/tests/basic/`
- [X] T002 [P] Create provider and version constraints in `modules/scc-standard/versions.tf` and `modules/scc-standard/providers.tf`
- [X] T003 [P] Create the base module interface in `modules/scc-standard/variables.tf`, `modules/scc-standard/outputs.tf`, and `modules/scc-standard/locals.tf`
- [X] T004 [P] Create the top-level orchestration file in `modules/scc-standard/main.tf`
- [X] T005 [P] Create the initial module documentation scaffold in `modules/scc-standard/README.md`, `modules/scc-standard/examples/basic/README.md`, and `modules/scc-standard/tests/basic/README.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared baseline components that all user stories depend on.

**⚠️ CRITICAL**: No user story work should start until this phase is complete.

- [X] T006 Create shared baseline locals for required services, deterministic names, and derived flags in `modules/scc-standard/locals.tf`
- [X] T007 [P] Create the required service activation resources in `modules/scc-standard/services.tf`
- [X] T008 [P] Add baseline status, enabled services, and shared derived outputs in `modules/scc-standard/outputs.tf`
- [X] T009 Create the base example consumer configuration in `modules/scc-standard/examples/basic/main.tf`
- [X] T010 Create the shared Terraform test harness in `modules/scc-standard/tests/basic/0-setup.tf`

**Checkpoint**: Foundation ready. User story work can now proceed in priority order or in parallel where staffing allows.

---

## Phase 3: User Story 1 - Prepare a project security baseline (Priority: P1) 🎯 MVP

**Goal**: Enable required project prerequisites and document the external SCC activation prerequisite for one project.

**Independent Test**: Apply the module for a project with required inputs only and confirm required services are enabled, manual SCC activation is documented, and re-apply does not require manual cleanup.

### Tests for User Story 1

- [X] T011 [P] [US1] Add the baseline-only example test case in `modules/scc-standard/tests/basic/1-example.tf`
- [X] T012 [P] [US1] Add baseline-preparation assertions in `modules/scc-standard/tests/basic/2-assert.tf`

### Implementation for User Story 1

- [X] T013 [US1] Implement baseline preparation wiring and dependency ordering in `modules/scc-standard/main.tf`
- [X] T014 [US1] Document manual SCC activation and baseline prerequisites in `modules/scc-standard/README.md`
- [X] T015 [US1] Refine required service dependencies and failure behavior in `modules/scc-standard/services.tf`
- [X] T016 [US1] Expose baseline preparation outputs in `modules/scc-standard/outputs.tf`
- [X] T017 [US1] Align the baseline example inputs and outputs in `modules/scc-standard/examples/basic/main.tf`

**Checkpoint**: User Story 1 is independently functional and validates the MVP onboarding path.

---

## Phase 4: User Story 2 - Grant the required access safely (Priority: P2)

**Goal**: Assign approved operator access without taking authoritative control of unrelated project IAM.

**Independent Test**: Apply the module with operator identities and verify required project IAM bindings are created while unrelated bindings are left untouched.

### Tests for User Story 2

- [X] T018 [P] [US2] Extend the Terraform example test with operator identity inputs in `modules/scc-standard/tests/basic/1-example.tf`
- [X] T019 [P] [US2] Add additive IAM assertions in `modules/scc-standard/tests/basic/2-assert.tf`

### Implementation for User Story 2

- [X] T020 [US2] Implement approved operator identity input validation and IAM maps in `modules/scc-standard/variables.tf` and `modules/scc-standard/locals.tf`
- [X] T021 [US2] Compose additive project IAM with `projects_iam` in `modules/scc-standard/iam.tf`
- [X] T022 [US2] Expose IAM-related outputs for validation in `modules/scc-standard/outputs.tf`
- [X] T023 [US2] Document approved operator access behavior in `modules/scc-standard/README.md`
- [X] T024 [US2] Update the example configuration to show optional operator identities in `modules/scc-standard/examples/basic/main.tf`

**Checkpoint**: User Stories 1 and 2 work together, and US2 remains independently testable through IAM-focused inputs and assertions.

---

## Phase 5: User Story 3 - Export security signals to operations (Priority: P3)

**Goal**: Optionally export SCC-related signals to a caller-supplied logging destination without affecting baseline-only onboarding.

**Independent Test**: Apply the module with logging integration enabled and confirm the logging sink is created for the configured destination; apply with logging disabled and confirm the baseline still converges without logging resources.

### Tests for User Story 3

- [X] T025 [P] [US3] Extend the Terraform example test with logging integration inputs in `modules/scc-standard/tests/basic/1-example.tf`
- [X] T026 [P] [US3] Add logging-enabled and logging-disabled assertions in `modules/scc-standard/tests/basic/2-assert.tf`

### Implementation for User Story 3

- [X] T027 [US3] Implement logging integration input validation and derived sink settings in `modules/scc-standard/variables.tf` and `modules/scc-standard/locals.tf`
- [X] T028 [US3] Compose the public log export module in `modules/scc-standard/logging.tf`
- [X] T029 [US3] Expose logging sink identifiers and writer identity outputs in `modules/scc-standard/outputs.tf`
- [X] T030 [US3] Document logging-only operational integration and monitoring exclusions in `modules/scc-standard/README.md`
- [X] T031 [US3] Update the example configuration to show optional logging integration in `modules/scc-standard/examples/basic/main.tf`

**Checkpoint**: All three user stories are independently testable, with logging integration remaining optional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency, verification, and cross-story documentation updates.

- [ ] T032 [P] Regenerate module documentation tables in `modules/scc-standard/README.md`
- [X] T033 [P] Run repository-style Terraform validation against `modules/scc-standard/examples/basic/main.tf` and `modules/scc-standard/tests/basic/`
- [X] T034 [P] Run repository lint and security checks for `modules/scc-standard/` through the existing workflow commands
- [X] T035 Update `/Users/aram.karapetzan/Development/dasmeta/terraform/terraform-google-modules/specs/004-scc-standard-wrapper/quickstart.md` to match the final module interface

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1: Setup**: No dependencies
- **Phase 2: Foundational**: Depends on Phase 1 and blocks all user stories
- **Phase 3: US1**: Depends on Phase 2
- **Phase 4: US2**: Depends on Phase 2 and can start after US1 module scaffolding is stable, though it should be delivered after US1 for MVP
- **Phase 5: US3**: Depends on Phase 2 and can start after shared outputs and locals are in place
- **Phase 6: Polish**: Depends on all implemented user stories

### User Story Dependencies

- **US1 (P1)**: No dependency on other user stories
- **US2 (P2)**: Shares module interface and outputs with US1, but its acceptance criteria are independently testable once foundational work is done
- **US3 (P3)**: Shares module interface and outputs with US1, but its acceptance criteria are independently testable once foundational work is done

### Within Each User Story

- Tests are written before implementation updates for that story
- Variable and local derivation updates precede resource/module composition
- Resource/module composition precedes outputs and documentation alignment

### Parallel Opportunities

- `T002` through `T005` can run in parallel after `T001`
- `T007` and `T008` can run in parallel after `T006`
- Within each user story, the test tasks marked `[P]` can run together
- After Phase 2, US2 and US3 can be staffed in parallel if the team accepts parallel feature development after the MVP path

---

## Parallel Example: User Story 1

```bash
Task: "Add the baseline-only example test case in modules/scc-standard/tests/basic/1-example.tf"
Task: "Add baseline convergence assertions in modules/scc-standard/tests/basic/2-assert.tf"
```

## Parallel Example: User Story 2

```bash
Task: "Extend the Terraform example test with operator identity inputs in modules/scc-standard/tests/basic/1-example.tf"
Task: "Add additive IAM assertions in modules/scc-standard/tests/basic/2-assert.tf"
```

## Parallel Example: User Story 3

```bash
Task: "Extend the Terraform example test with logging integration inputs in modules/scc-standard/tests/basic/1-example.tf"
Task: "Add logging-enabled and logging-disabled assertions in modules/scc-standard/tests/basic/2-assert.tf"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Validate the baseline-only onboarding flow before moving on

### Incremental Delivery

1. Deliver US1 for baseline convergence
2. Add US2 for additive IAM access assignment
3. Add US3 for optional logging export
4. Finish with cross-cutting validation and documentation sync

### Parallel Team Strategy

1. One developer completes Setup and Foundational work
2. A second developer can prepare US2 tasks while the first validates US1
3. A third developer can take US3 once shared locals, outputs, and test harness files are stable

---

## Notes

- All tasks use the required checklist format with task IDs, optional `[P]` markers, story labels for story phases, and exact file paths
- The module remains scoped to one project per instance
- Monitoring artifacts stay out of scope for v1 and should not appear in implementation tasks
- Documentation, example, and tests stay aligned with every story phase

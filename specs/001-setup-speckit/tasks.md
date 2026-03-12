# Tasks: Setup Speckit For This Repo

**Input**: Design documents from `/specs/001-setup-speckit/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: No explicit TDD or automated test requirement was requested in the feature specification. Validation tasks below cover artifact and workflow verification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare the repository workflow surface for this feature and align the generated planning artifacts.

- [x] T001 Update the feature specification in `specs/001-setup-speckit/spec.md`
- [x] T002 Update the implementation plan in `specs/001-setup-speckit/plan.md`
- [x] T003 [P] Capture planning decisions in `specs/001-setup-speckit/research.md`
- [x] T004 [P] Capture planning entities and states in `specs/001-setup-speckit/data-model.md`
- [x] T005 [P] Document workflow scenarios in `specs/001-setup-speckit/quickstart.md`
- [x] T006 [P] Define governance resolution behavior in `specs/001-setup-speckit/contracts/speckit-governance-contract.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish repository-wide enforcement primitives that all user stories depend on.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T007 Create the repository authority reference in `docs/terraform-module-authority.md`
- [x] T008 Update repository-local governance rules in `.specify/memory/constitution.md`
- [x] T009 [P] Wire Terraform authority resolution into `.codex/prompts/speckit.plan.md`
- [x] T010 [P] Wire Terraform authority resolution into `.codex/prompts/speckit.analyze.md`
- [x] T011 [P] Wire Terraform authority resolution into `.codex/prompts/speckit.implement.md`
- [x] T012 Validate the authority chain across `docs/terraform-module-authority.md`, `.specify/memory/constitution.md`, `.codex/prompts/speckit.plan.md`, `.codex/prompts/speckit.analyze.md`, and `.codex/prompts/speckit.implement.md`

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Initialize Repo Workflow (Priority: P1) 🎯 MVP

**Goal**: Enable contributors to start Speckit feature work in this repository and get the expected repository-scoped artifacts.

**Independent Test**: Start a feature workflow in the repository and confirm the generated artifacts under `specs/<feature>/` are usable without manual scaffolding.

### Implementation for User Story 1

- [x] T013 [US1] Review the generated feature initialization flow in `.specify/scripts/bash/create-new-feature.sh`
- [x] T014 [US1] Align the specification scaffold expectations in `.specify/templates/spec-template.md`
- [x] T015 [US1] Align the planning scaffold expectations in `.specify/templates/plan-template.md`
- [x] T016 [US1] Validate feature initialization and plan setup behavior with `.specify/scripts/bash/create-new-feature.sh` and `.specify/scripts/bash/setup-plan.sh`

**Checkpoint**: User Story 1 should allow a maintainer to create and plan a repository feature without manual artifact setup

---

## Phase 4: User Story 2 - Apply Terraform Module Governance (Priority: P2)

**Goal**: Ensure Terraform module workflow steps resolve and enforce the referenced Terraform module development skill instead of local duplicated rules.

**Independent Test**: Review a Terraform-module-oriented workflow path and confirm the repository reads `docs/terraform-module-authority.md`, resolves the referenced skill, and stops when the authority cannot be read.

### Implementation for User Story 2

- [x] T017 [US2] Define the repository-owned authority reference rules in `docs/terraform-module-authority.md`
- [x] T018 [US2] Encode reference-based Terraform governance requirements in `specs/001-setup-speckit/spec.md`
- [x] T019 [US2] Align the planning contract in `specs/001-setup-speckit/contracts/speckit-governance-contract.md`
- [x] T020 [US2] Validate Terraform planning behavior in `.codex/prompts/speckit.plan.md`
- [x] T021 [US2] Validate Terraform analysis behavior in `.codex/prompts/speckit.analyze.md`
- [x] T022 [US2] Validate Terraform implementation behavior in `.codex/prompts/speckit.implement.md`

**Checkpoint**: User Story 2 should make Terraform workflow governance reference-based, explicit, and fail-closed

---

## Phase 5: User Story 3 - Onboard Contributors Consistently (Priority: P3)

**Goal**: Give contributors minimal but sufficient repository guidance to understand the workflow and authority chain.

**Independent Test**: A contributor can read repository-managed guidance and generated feature artifacts, then identify the next workflow step and the Terraform governance authority chain in one pass.

### Implementation for User Story 3

- [x] T023 [US3] Add contributor-facing authority guidance in `docs/terraform-module-authority.md`
- [x] T024 [US3] Capture contributor workflow expectations in `specs/001-setup-speckit/quickstart.md`
- [x] T025 [US3] Update agent-facing repository guidance in `AGENTS.md`
- [x] T026 [US3] Validate that contributor guidance stays within scoped workflow documentation using `docs/terraform-module-authority.md`, `specs/001-setup-speckit/quickstart.md`, and `AGENTS.md`

**Checkpoint**: User Story 3 should let contributors understand the workflow boundary and authority chain without a broad documentation rewrite

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency checks and completion validation across all affected artifacts

- [x] T027 [P] Normalize terminology across `specs/001-setup-speckit/spec.md`, `specs/001-setup-speckit/plan.md`, and `specs/001-setup-speckit/contracts/speckit-governance-contract.md`
- [x] T028 [P] Re-run agent context generation with `.specify/scripts/bash/update-agent-context.sh codex`
- [x] T029 Validate the quickstart flow in `specs/001-setup-speckit/quickstart.md`
- [x] T030 Validate final repository changes with `git diff` and targeted file review for `docs/terraform-module-authority.md`, `.specify/memory/constitution.md`, `.codex/prompts/`, `specs/001-setup-speckit/`, and `AGENTS.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational completion
- **User Story 2 (Phase 4)**: Depends on Foundational completion and benefits from User Story 1 artifact validation
- **User Story 3 (Phase 5)**: Depends on Foundational completion and uses outputs from User Stories 1 and 2
- **Polish (Phase 6)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - no dependency on other stories
- **User Story 2 (P2)**: Can start after Foundational - depends on repository governance primitives, not on US3
- **User Story 3 (P3)**: Can start after Foundational - should use settled workflow and authority wording from US1 and US2

### Within Each User Story

- Update core artifact definitions before validation tasks
- Keep authority reference wording consistent with repository governance
- Complete story validation before moving to the next lower-priority story

### Parallel Opportunities

- `T003`, `T004`, `T005`, and `T006` can run in parallel after `T001` and `T002`
- `T009`, `T010`, and `T011` can run in parallel after `T007` and `T008`
- `T027` and `T028` can run in parallel during the polish phase

---

## Parallel Example: User Story 2

```bash
# Launch prompt wiring reviews together after authority and constitution updates:
Task: "Wire Terraform authority resolution into .codex/prompts/speckit.plan.md"
Task: "Wire Terraform authority resolution into .codex/prompts/speckit.analyze.md"
Task: "Wire Terraform authority resolution into .codex/prompts/speckit.implement.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Confirm Speckit feature initialization and plan setup work in this repository

### Incremental Delivery

1. Complete Setup + Foundational -> repository governance baseline ready
2. Add User Story 1 -> validate feature workflow scaffolding
3. Add User Story 2 -> validate Terraform authority resolution and fail-closed behavior
4. Add User Story 3 -> validate contributor-facing workflow guidance
5. Finish with Polish -> verify terminology, agent context, and final diff

### Parallel Team Strategy

With multiple developers:

1. One developer handles Setup artifacts
2. One developer prepares authority and constitution updates
3. After Foundational is complete:
   - Developer A: User Story 1 template/workflow validation
   - Developer B: User Story 2 prompt and authority validation
   - Developer C: User Story 3 contributor guidance alignment

---

## Notes

- All tasks follow the required checklist format with IDs and exact file paths
- User story phases use `[US1]`, `[US2]`, and `[US3]` labels consistently
- Automated test tasks were not generated because the specification did not require TDD or explicit automated tests
- Validation tasks are still included so each story remains independently testable

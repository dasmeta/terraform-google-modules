# Data Model: Setup Speckit For This Repo

## Entity: Feature Workspace

- **Purpose**: Represents one Speckit-managed feature inside the repository.
- **Fields**:
  - `branch_name`: unique feature branch identifier
  - `feature_dir`: absolute path to the feature artifact directory
  - `spec_file`: path to the feature specification
  - `plan_file`: path to the implementation plan
  - `tasks_file`: path to the task breakdown after planning
- **Relationships**:
  - owns one `Specification Artifact`
  - may own one `Authority Reference` when Terraform module governance applies
- **Validation rules**:
  - `branch_name` must match the generated feature naming pattern
  - `feature_dir` must remain inside the repository `specs/` tree

## Entity: Specification Artifact

- **Purpose**: Captures feature intent, user scenarios, requirements, and
  clarifications.
- **Fields**:
  - `title`
  - `status`
  - `user_stories`
  - `requirements`
  - `success_criteria`
  - `clarifications`
- **Relationships**:
  - belongs to one `Feature Workspace`
  - informs one `Implementation Plan`
- **Validation rules**:
  - must include mandatory sections required by the Speckit template
  - must remain free of unresolved critical ambiguities before planning

## Entity: Authority Reference

- **Purpose**: Describes where Terraform module guidance comes from and how it
  is applied in this repository.
- **Fields**:
  - `documentation_source`
  - `runtime_skill_path`
  - `precedence_order`
  - `failure_behavior`
- **Relationships**:
  - may be attached to a `Feature Workspace`
  - is enforced by repository-local governance rules
- **Validation rules**:
  - must point to a repository-visible authority document
  - runtime skill path must be readable when Terraform module work is in scope
  - precedence order must keep the repository constitution first

## Entity: Contributor Guidance

- **Purpose**: Explains how contributors use Speckit and interpret governance in
  this repository.
- **Fields**:
  - `workflow_entry_points`
  - `next_phase_rules`
  - `authority_chain_summary`
- **Relationships**:
  - references one `Authority Reference`
  - supports one or more `Feature Workspace` flows
- **Validation rules**:
  - must stay within the scoped workflow guidance for this feature
  - must not restate detailed Terraform module standards copied from the skill

## State Transitions

### Feature Workspace

`initialized` -> `specified` -> `clarified` -> `planned` -> `tasked` -> `implemented`

- `initialized`: feature branch and directory exist
- `specified`: `spec.md` is created
- `clarified`: critical ambiguities are resolved in the spec
- `planned`: `plan.md`, `research.md`, `data-model.md`, `quickstart.md`, and
  any contracts are produced
- `tasked`: `tasks.md` is generated later
- `implemented`: execution artifacts land in the repository

### Authority Reference

`declared` -> `resolved` -> `enforced`

- `declared`: authority document exists in the repo
- `resolved`: runtime skill path is read successfully
- `enforced`: planning, analysis, or implementation use the resolved authority

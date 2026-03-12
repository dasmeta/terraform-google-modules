# Implementation Plan: Setup Speckit For This Repo

**Branch**: `001-setup-speckit` | **Date**: 2026-03-12 | **Spec**: [/Users/aram.karapetzan/Development/dasmeta/terraform/terraform-google-modules/specs/001-setup-speckit/spec.md](/Users/aram.karapetzan/Development/dasmeta/terraform/terraform-google-modules/specs/001-setup-speckit/spec.md)
**Input**: Feature specification from `/specs/001-setup-speckit/spec.md`

**Note**: This plan covers repository workflow wiring and governance artifacts only. It does not introduce Terraform module rule duplication into this repository.

## Summary

Establish a usable Speckit workflow for this repository, then wire Terraform
module planning and implementation so they resolve a repository-managed
authority reference to the `terraform-module-developer` skill instead of
embedding volatile Terraform module rules locally.

## Technical Context

**Language/Version**: Markdown, Bash, existing repository YAML/JSON config  
**Primary Dependencies**: Existing `.specify/` scripts, `.codex/prompts/`,
repository Git workflows, referenced `terraform-module-developer` skill  
**Storage**: Repository files only  
**Testing**: Direct artifact verification, prompt/path validation, existing repo
automation remains unchanged  
**Target Platform**: Local contributor workflow in this Git repository  
**Project Type**: Repository workflow and governance configuration  
**Performance Goals**: Contributors can start and route Speckit workflow steps
without extra manual setup or repeated clarification  
**Constraints**: Keep Terraform module rules reference-based, preserve current
repo structure, do not expand into broad documentation refresh, fail closed when
authority cannot be resolved  
**Scale/Scope**: Repo-wide Speckit setup affecting `.specify/`, `.codex/`,
`docs/`, and feature artifacts under `specs/001-setup-speckit/`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- `PASS`: Repository-local governance remains the top-priority policy for this
  repo.
- `PASS`: Terraform module work uses
  `docs/terraform-module-authority.md` as the stable repository entry point.
- `PASS`: Terraform module workflow behavior is reference-based; the plan does
  not duplicate detailed `terraform-module-developer` skill rules into local
  governance.
- `PASS`: Terraform module workflow steps must resolve the referenced runtime
  skill before planning, analysis, or implementation.
- `PASS`: The design fails closed when the authority document or runtime skill
  cannot be read.
- `PASS`: Scope stays inside this repository and does not alter Terraform module
  implementations directly.

## Project Structure

### Documentation (this feature)

```text
specs/001-setup-speckit/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── speckit-governance-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
.codex/
└── prompts/
    ├── speckit.analyze.md
    ├── speckit.implement.md
    └── speckit.plan.md

.specify/
├── memory/
│   └── constitution.md
├── scripts/
│   └── bash/
│       └── update-agent-context.sh
└── templates/
    ├── plan-template.md
    └── spec-template.md

docs/
└── terraform-module-authority.md

modules/
├── container-registry/
├── dns-zone/
├── firebase/
├── ingress/
├── secret/
├── service-accounts/
├── sso-rbac/
└── uptime-check/
```

**Structure Decision**: Keep the work in existing repository workflow and
governance directories. No new application source tree is needed because this
feature changes repository behavior, not a standalone runtime component.

## Phase 0: Research Summary

- Confirm the repository already contains Speckit templates, scripts, and Codex
  prompt files.
- Confirm Terraform module governance in this repo must be reference-based and
  routed through `docs/terraform-module-authority.md`.
- Confirm the runtime authority path points to the installed
  `terraform-module-developer` skill and its bundled references.
- Confirm repo automation already exists through GitHub workflows,
  pre-commit, and release tooling and does not need structural expansion for
  this feature.

## Phase 1: Design Decisions

### Artifact Strategy

- Use `.specify/memory/constitution.md` for stable enforcement rules only.
- Use `docs/terraform-module-authority.md` as the repository-owned authority
  resolution document.
- Use `.codex/prompts/speckit.plan.md`,
  `.codex/prompts/speckit.implement.md`, and
  `.codex/prompts/speckit.analyze.md` to force explicit authority resolution
  during workflow execution.

### Terraform Module Scope Boundary

- Terraform module standards remain authoritative in the referenced external
  skill.
- This feature only defines how the repository loads, validates, and enforces
  that authority for Terraform module work.

### Validation Strategy

- Validate generated feature flow using Speckit scripts.
- Validate prompt wiring by checking that plan, analyze, and implement prompts
  explicitly load the authority document and fail when the runtime skill cannot
  be resolved.
- Validate documentation by checking contributors can identify the authority
  chain in one pass.

## Complexity Tracking

No constitution violations or justified complexity exceptions are expected for
this feature.

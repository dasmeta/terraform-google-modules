<!--
Sync Impact Report
Version change: template -> 1.0.0
Modified principles:
- placeholder principle set -> I. Repository Constitution First
- placeholder principle set -> II. External Terraform Module Authority
- placeholder principle set -> III. Explicit Resolution Over Implicit Reference
- placeholder principle set -> IV. Fail Closed On Missing Authority
- placeholder principle set -> V. Keep Local Rules Stable
Added sections:
- Authority Resolution
- Workflow Enforcement
Removed sections:
- none
Templates requiring updates:
- ✅ .codex/prompts/speckit.plan.md
- ✅ .codex/prompts/speckit.implement.md
- ✅ .codex/prompts/speckit.analyze.md
Follow-up TODOs:
- none
-->
# Terraform Google Modules Constitution

## Core Principles

### I. Repository Constitution First
This constitution defines repository-local governance. Speckit and human
contributors MUST treat it as the highest-priority repository policy. External
shared standards may extend local guidance, but they MUST NOT silently override
explicit constitution statements.

### II. External Terraform Module Authority
Terraform module creation, extension, and standardization work in this
repository MUST use the authority reference defined in
`docs/terraform-module-authority.md`. That document is the stable repository
entry point for both human documentation and Speckit runtime resolution.

### III. Explicit Resolution Over Implicit Reference
For Terraform module work, Speckit MUST explicitly load the repository authority
document and then resolve the referenced runtime skill before planning,
analysis, or implementation. Mentioning Terraform module standards without
loading the referenced authority is non-compliant.

### IV. Fail Closed On Missing Authority
If the authority document or its runtime skill reference cannot be read,
Speckit MUST stop and report the missing dependency instead of continuing with
guessed or partial Terraform module standards.

### V. Keep Local Rules Stable
This repository SHOULD keep volatile Terraform module rules out of the local
constitution. Rapidly changing module guidance belongs in the centrally managed
shared standards source referenced by `docs/terraform-module-authority.md`,
while this constitution remains focused on stable enforcement behavior.

## Authority Resolution

Terraform module work is any feature, analysis, or implementation that creates,
extends, standardizes, or reviews Terraform modules or their repository-level
module scaffolding.

For that work:

- Speckit MUST read `docs/terraform-module-authority.md`.
- Speckit MUST load the runtime authority referenced there.
- Speckit MUST apply the resolved authority during `specify`, `plan`,
  `analyze`, and `implement` flows when those flows touch Terraform module work.
- If a future central governance artifact replaces the current runtime skill,
  this repository SHOULD update only the authority document unless local
  enforcement behavior changes.

## Workflow Enforcement

Constitution compliance review for Terraform module work MUST confirm:

- the authority document was loaded
- the runtime authority was successfully resolved
- planning and analysis treated authority conflicts as blocking
- implementation did not proceed after authority resolution failure

Repository prompt or template changes that affect Speckit behavior MUST preserve
this enforcement model.

## Governance

This constitution supersedes other repository-local workflow guidance when
conflicts arise. Amendments require updating `.specify/memory/constitution.md`
and any dependent Speckit prompts whose behavior enforces the amended rules.

Versioning policy:

- MAJOR: incompatible governance changes or removed principles
- MINOR: new principles or materially expanded enforcement behavior
- PATCH: clarifications and wording-only refinements

Compliance reviews for Terraform module work MUST verify the authority chain:
constitution -> `docs/terraform-module-authority.md` -> resolved runtime skill.

**Version**: 1.0.0 | **Ratified**: 2026-03-12 | **Last Amended**: 2026-03-12

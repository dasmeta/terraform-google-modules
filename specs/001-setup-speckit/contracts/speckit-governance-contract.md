# Contract: Speckit Governance Resolution

## Purpose

Define the observable contract for how Speckit must behave in this repository
when a feature touches Terraform module work.

## Inputs

- Active feature specification under `specs/<feature>/spec.md`
- Repository constitution at `.specify/memory/constitution.md`
- Repository authority document at `docs/terraform-module-authority.md`
- Referenced runtime skill path declared by the authority document

## Contract Rules

1. For non-Terraform feature work, Speckit may proceed using the standard
   repository workflow without Terraform-specific authority checks.
2. For Terraform module work, Speckit must read
   `docs/terraform-module-authority.md` before planning, analysis, or
   implementation.
3. For Terraform module work, Speckit must resolve the runtime skill path
   declared by the authority document before proceeding.
4. If the authority document or runtime skill cannot be read, Speckit must stop
   the gated workflow step and report the missing authority.
5. Repository-local files may define authority resolution, precedence, and
   enforcement behavior, but may not duplicate the detailed Terraform module
   rules carried by the referenced skill.

## Success Conditions

- Contributors can identify the authority chain from repo artifacts alone.
- Planning artifacts explicitly mention authority resolution for Terraform
  module work.
- Analyze and implement flows treat missing authority as blocking.

## Failure Conditions

- Terraform module planning or implementation proceeds without loading the
  authority document.
- The repo copies detailed Terraform module rules instead of referencing the
  skill.
- Contributors cannot identify whether the skill or the repository is the
  source of a given rule.

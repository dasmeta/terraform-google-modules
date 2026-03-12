# Terraform Module Authority

## Purpose

This repository does not copy Terraform module development standards into its
local constitution. For Terraform module creation, extension, and
standardization work, the repository uses a reference-based authority model.

## Documentation Authority

For human-readable governance ownership and shared standards publication, use
the central Dasmeta constitution repository:

- Repository: `https://github.com/dasmeta/constitution`
- Local workspace path when available:
  `/Users/aram.karapetzan/Development/dasmeta/constitution`

That repository is the governance home for shared standards. This repository
should point there for documentation and ownership context rather than copying
rapidly changing guidance into local governance files.

## Runtime Authority For Speckit

For actual Terraform module workflow execution in Codex and Speckit, use the
installed shared skill:

- Primary runtime path:
  `.codex/constitution/skills/terraform-module-developer/SKILL.md`

The referenced skill includes bundled standards and planning references that are
part of the runtime authority for Terraform module work.

## Resolution Rules

When Speckit identifies Terraform module work, it MUST:

1. Read this file.
2. Load the runtime authority from the installed skill path.
3. Apply the skill and its bundled references during planning, analysis, and
   implementation.
4. Stop and report an authority resolution failure if the runtime path cannot be
   read.

## Precedence

Precedence for Terraform module work in this repository:

1. `.specify/memory/constitution.md`
2. `docs/terraform-module-authority.md`
3. Installed `terraform-module-developer` skill and its bundled references

If the runtime authority conflicts with an explicit repository constitution
statement, the repository constitution wins.

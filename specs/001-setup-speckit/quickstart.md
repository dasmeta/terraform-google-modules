# Quickstart: Setup Speckit For This Repo

## Scenario 1: Start a new feature in this repository

1. Create a feature workspace with the Speckit feature creation flow.
2. Open the generated `spec.md` under `specs/<feature>/`.
3. Clarify high-impact ambiguities before planning.
4. Run the planning flow to generate `plan.md`, `research.md`,
   `data-model.md`, `quickstart.md`, and any required contracts.

**Expected result**: The contributor can move from a new feature request to a
planned repository change without manually assembling workflow files.

## Scenario 2: Plan Terraform module workflow changes

1. Confirm the feature involves Terraform module work or Terraform module
   governance behavior.
2. Read `docs/terraform-module-authority.md`.
3. Confirm the authority document points to the installed
   `terraform-module-developer` skill.
4. Run the Speckit planning flow.

**Expected result**: Planning artifacts reflect the repository-local
enforcement rules and reference the skill as the authoritative Terraform module
guidance source.

## Scenario 3: Handle missing authority cleanly

1. Start a Terraform module workflow step.
2. Attempt to resolve the authority document and referenced runtime skill.
3. If either cannot be read, stop the workflow step immediately and report the
   missing authority path.

**Expected result**: The workflow fails closed instead of guessing Terraform
module standards.

# Research: Setup Speckit For This Repo

## Decision 1: Treat this as repository workflow configuration, not module code

- **Decision**: Implement the feature through repository governance documents,
  Speckit prompt files, and Speckit-generated planning artifacts.
- **Rationale**: The feature changes how contributors and Speckit operate in
  the repository. It does not add or change a Terraform module resource model.
- **Alternatives considered**:
  - Modify Terraform modules directly: rejected because the spec is about repo
    workflow setup, not module behavior.
  - Add a standalone helper application: rejected because existing `.specify/`
    and `.codex/` assets already provide the workflow surface.

## Decision 2: Keep Terraform guidance reference-based

- **Decision**: Repository-local files define only resolution, precedence, and
  enforcement behavior, while detailed Terraform module standards remain in the
  referenced `terraform-module-developer` skill.
- **Rationale**: The user explicitly wants the repo to reference the skill
  rather than duplicate rules that change frequently.
- **Alternatives considered**:
  - Copy the skill rules into the constitution: rejected because it creates
    drift and duplicate governance sources.
  - Reference the skill informally without workflow enforcement: rejected
    because Speckit would not reliably dereference it during planning and
    implementation.

## Decision 3: Use a repo-local authority document as the indirection layer

- **Decision**: Add `docs/terraform-module-authority.md` as the stable
  repository-owned authority pointer for both humans and Speckit.
- **Rationale**: A repo-local reference keeps the constitution stable, gives
  prompts a deterministic file to read, and lets the central governance source
  evolve independently.
- **Alternatives considered**:
  - Point the constitution directly to a mutable home-directory skill path:
    rejected because it is brittle as a user-facing documentation target.
  - Put all authority details directly in prompts: rejected because it hides the
    governance chain from contributors and splits the source of truth.

## Decision 4: Fail closed when authority resolution fails

- **Decision**: Planning, analysis, and implementation for Terraform module
  work stop if the authority document or the referenced runtime skill cannot be
  read.
- **Rationale**: This matches the repository constitution and avoids partial or
  guessed Terraform governance behavior.
- **Alternatives considered**:
  - Continue with best-effort defaults: rejected because it violates the
    constitution's explicit resolution rule.
  - Warn but continue: rejected because warnings are too weak for governance
    enforcement.

## Decision 5: Keep contributor guidance minimal and directly tied to workflow

- **Decision**: Only update contributor-facing documentation required to explain
  the authority chain and Speckit workflow expectations for this feature.
- **Rationale**: The clarified scope explicitly excludes a broad documentation
  refresh.
- **Alternatives considered**:
  - Rewrite repository docs broadly: rejected as out of scope.
  - Skip user-facing guidance entirely: rejected because the spec requires
    contributors to identify the authority source and next workflow step.

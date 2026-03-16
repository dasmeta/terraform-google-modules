# terraform-google-modules Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-03-12

## Active Technologies
- Repository files only (001-setup-speckit)
- Terraform `>= 1.3` + HashiCorp Google provider, optional Google Beta provider, `terraform-google-modules/project-factory/google` for API activation patterns, `terraform-google-modules/iam/google//modules/projects_iam`, `terraform-google-modules/log-export/google` (004-scc-standard-wrapper)
- Terraform state only (004-scc-standard-wrapper)
- Terraform `>= 1.3` + HashiCorp Google provider, optional HashiCorp Google Beta provider, direct `google_project_service` resources for required API activation, `terraform-google-modules/iam/google//modules/projects_iam` for additive IAM, `terraform-google-modules/log-export/google` for optional logging sink integration (004-scc-standard-wrapper)

- Markdown, Bash, existing repository YAML/JSON config + Existing `.specify/` scripts, `.codex/prompts/`, (001-setup-speckit)

## Project Structure

```text
src/
tests/
```

## Commands

# Add commands for Markdown, Bash, existing repository YAML/JSON config

## Code Style

Markdown, Bash, existing repository YAML/JSON config: Follow standard conventions

## Recent Changes
- 004-scc-standard-wrapper: Added Terraform `>= 1.3` + HashiCorp Google provider, optional HashiCorp Google Beta provider, direct `google_project_service` resources for required API activation, `terraform-google-modules/iam/google//modules/projects_iam` for additive IAM, `terraform-google-modules/log-export/google` for optional logging sink integration
- 004-scc-standard-wrapper: Added Terraform `>= 1.3` + HashiCorp Google provider, optional Google Beta provider, `terraform-google-modules/project-factory/google` for API activation patterns, `terraform-google-modules/iam/google//modules/projects_iam`, `terraform-google-modules/log-export/google`
- 001-setup-speckit: Added Markdown, Bash, existing repository YAML/JSON config + Existing `.specify/` scripts, `.codex/prompts/`,


<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->

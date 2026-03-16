module "project_iam" {
  count = length(local.operator_bindings) > 0 ? 1 : 0

  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 8.0"

  projects = [var.project_id]
  mode     = "additive"
  bindings = local.operator_bindings

  depends_on = [google_project_service.required]
}

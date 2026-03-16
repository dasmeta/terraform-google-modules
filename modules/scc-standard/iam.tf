resource "google_project_iam_member" "project_role_member" {
  for_each = local.project_role_members

  project = var.project_id
  role    = each.value.role
  member  = each.value.member

  depends_on = [
    google_project_service.required,
  ]
}

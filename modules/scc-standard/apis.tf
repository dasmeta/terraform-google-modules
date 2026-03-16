resource "google_project_service" "required" {
  for_each = local.required_services

  project                    = var.project_id
  service                    = each.value
  disable_on_destroy         = var.disable_services_on_destroy
  disable_dependent_services = false
}

resource "google_project_service_identity" "service_identity" {
  provider = google-beta
  for_each = toset(var.service_identity_services)

  project = var.project_id
  service = each.value

  depends_on = [
    google_project_service.required,
  ]
}

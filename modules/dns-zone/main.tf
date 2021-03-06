

provider "google" {
  credentials = file("${var.key_path}")
}


resource "google_dns_managed_zone" "this" {
  project     = var.project_id
  name        = replace(var.name, ".", "-")
  dns_name    = var.name
  description = var.description
}

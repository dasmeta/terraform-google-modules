module "this" {
  source = "../.."

  secrets = {
    "product-dev-service-username" = "admin"
    "product-dev-service-password" = "root"
  }

  labels = {
    environment = "development"
    team        = "backend"
  }
}

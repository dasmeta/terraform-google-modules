terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 4.63"
    }
  }
}

provider "google" {
  project     = "my-project"
  region      = "us-east1"
  credentials = file("/path/to/gcp/config.json")
}

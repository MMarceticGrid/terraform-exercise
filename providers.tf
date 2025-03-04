terraform {
  required_version = "1.10.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.21.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_project_service" "services" {
  for_each = toset(var.services)
  project    = var.project_id
  service = each.value
}
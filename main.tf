terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-mmarcetic"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "gd-gcp-internship-devops"
  region  = var.region
  zone    = var.zone
}
module "network" {
  source = "./modules/network"
  region = var.region
}

module "compute" {
  source = "./modules/compute"
  zone   = var.zone
  region = var.region
}

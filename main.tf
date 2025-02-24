module "network" {
  source = "./modules/network"
  region = var.region
}

module "compute" {
  source = "./modules/compute"
  zone   = var.zone
  region = var.region
}

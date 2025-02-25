module "network" {
  source         = "./modules/network"
  subnets        = var.subnets
  network_name   = var.network_name
  firewall_rules = var.firewall_rules
}

module "compute" {
  source                = "./modules/compute"
  zone                  = var.zone
  region                = var.region
  network_name          = var.network_name
}

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
  forwarding_rule       = var.forwarding_rule
  health_check          = var.health_check
  group_manager         = var.group_manager
  target_pool_name      = var.target_pool_name
  instance_template     = var.instance_template
  temp_compute_img_name = var.temp_compute_img_name
  environment           = var.environment
}

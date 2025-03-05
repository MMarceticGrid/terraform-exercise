module "network" {
  source         = "./modules/network"
  subnets        = var.subnets
  network_name   = var.network_name
  firewall_rules = var.firewall_rules
  region         = var.region
  compute_router_name = var.compute_router_name
  compute_router_nat = var.compute_router_nat
}

module "compute" {
  source          = "./modules/compute"
  zone            = var.zone
  region          = var.region
  network_name    = var.network_name
  forwarding_rule = var.forwarding_rule
  health_check    = var.health_check
  group_manager   = var.group_manager
  instance_template     = var.instance_template
  temp_compute_img_name = var.temp_compute_img_name
  environment           = var.environment
  vm_image              = var.vm_image
  web_map_backend_service = var.web_map_backend_service
  web_map_name = var.web_map_name
  lb_proxy_name = var.lb_proxy_name
}

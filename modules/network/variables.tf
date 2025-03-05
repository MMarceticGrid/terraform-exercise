variable "network_name" {
  type = string
}

variable "subnets" {
  type = map(object({
    name       = string
    cidr_range = string
    region     = string
  }))
}

variable "firewall_rules" {
  description = "Map of firewall rules to create"
  type = map(object({
    name = string
    allowed = object({
      protocol = string
      ports    = list(string)
    })
    source_ranges = list(string)
  }))
}

variable "region" {
  type = string
}

variable "compute_router_name" {
  type = string
}

variable "compute_router_nat" {
  type = map(object({
    name                               = string
    nat_ip_allocate_option             = string
    source_subnetwork_ip_ranges_to_nat = string
  }))
}
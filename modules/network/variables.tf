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
    target_tags   = list(string)
  }))
}
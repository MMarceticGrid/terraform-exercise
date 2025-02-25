variable "region" {
  type        = string
  description = "Region configuration"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Zone configuration"
  default     = "us-central1-a"
}

variable "network_name" {
  type    = string
  default = "main-network"
}

variable "subnets" {
  type = map(object({
    name       = string
    cidr_range = string
    region     = string
  }))
  default = {
    "subnet-1" = {
      name       = "priv"
      cidr_range = "10.0.0.0/26"
      region     = "us-central1"
    },
    "subnet-2" = {
      name       = "db"
      cidr_range = "10.0.0.64/26"
      region     = "us-central1"
    }
  }
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
  default = {
    "allow-lb" = {
      name = "mm-allow-lb"
      allowed = {
        protocol = "tcp"
        ports    = ["80"]
      }
      source_ranges = [
        "130.211.0.0/22",
        "35.191.0.0/16",
        "35.202.66.202"
      ]
      target_tags = ["web-server"]
    },
    "allow-http" = {
      name = "mm-allow-http"
      allowed = {
        protocol = "tcp"
        ports    = ["80"]
      }
      source_ranges = [
        "130.211.0.0/22",
        "35.191.0.0/16",
        "35.202.66.202"
      ]
      target_tags = ["web-server"]
    },
    "allow-ssh-from-iap" = {
      name = "mm-allow-ssh-from-iap"
      allowed = {
        protocol = "tcp"
        ports    = ["22"]
      }
      source_ranges = [
        "35.235.240.0/20"
      ]
      target_tags = ["web-server"]
    }
  }
}


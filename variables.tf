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

variable "forwarding_rule" {
  type = map(object({
    name        = string
    port_range  = string
    ip_protocol = string
  }))
  default = {
    "app_forwarding_rule" = {
      name        = "web-app-forwarding-rule"
      port_range  = "80"
      ip_protocol = "TCP"
    }
  }
}

variable "health_check" {
  type = map(object({
    name                = string
    timeout_sec         = number
    check_interval_sec  = number
    healthy_threshold   = number
    unhealthy_threshold = number
    tcp_health_check = object({
      port = number
    })
  }))
  default = {
    "app_health_check" = {
      name = "app-health-check"

      timeout_sec         = 5
      check_interval_sec  = 5
      healthy_threshold   = 4
      unhealthy_threshold = 5

      tcp_health_check = {
        port = 80
      }
    }
  }
}

variable "group_manager" {
  type = map(object({
    name = string
    named_port = object({
      name = string
      port = number
    })
    base_instance_name = string
  }))
  default = {
    "web_instance_group" = {
      name = "web-instance-group"
      named_port = {
        name = "http"
        port = 80
      }
      base_instance_name = "web-instance"
    }
  }
}

variable "target_pool_name" {
  type    = string
  default = "web-app-target-pool"
}

variable "instance_template" {
  type = map(object({
    name = string
    disk = object({
      auto_delete = bool
      boot        = bool
    })
  }))
  default = {
    "web_instance_template" = {
      name = "web-instance-template"
      disk = {
        auto_delete = true
        boot        = true
      }
  } }
}
variable "temp_compute_img_name" {
  type    = string
  default = "custom-apache-image"
}

variable "environment" {
  type    = string
  default = "test"
}
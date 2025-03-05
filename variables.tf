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
  default = "mmarcetic-network"
}

variable "vm_image" {
  type    = string
  default = "debian-11-bullseye-v20220118"
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
    },
    "allow-ssh-from-iap" = {
      name = "mm-allow-ssh-from-iap"
      allowed = {
        protocol = "tcp"
        ports    = ["22"]
      }
      source_ranges = [
        "35.235.240.0/20",
        "35.202.66.202"
      ]
    },
    "allow-ssh-internal" = {
      name    = "allow-ssh-internal"
      allowed = {
        protocol = "tcp"
        ports    = ["22"]
      }
      source_ranges = ["10.128.0.0/9"]
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
      name = "mm-instance-group"
      named_port = {
        name = "http"
        port = 80
      }
      base_instance_name = "web-instance"
    }
  }
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
  default = "test-"
}

variable "compute_router_name" {
  type    = string
  default = "nat-router-us-central1"
}

variable "compute_router_nat" {
  type = map(object({
    name                               = string
    nat_ip_allocate_option             = string
    source_subnetwork_ip_ranges_to_nat = string
  }))
  default = {
    "nat_config1" = {
      name                               = "nat-config1"
      nat_ip_allocate_option             = "AUTO_ONLY"
      source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    }
  }
}
variable "services" {
  type = list(string)
  default = [ 
    "cloudapis.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com"
  ]
}

variable "web_map_backend_service" {
  type = object({
    name = string
    protocol = string
    port_name = string
  })
  default = {
    name          = "web-map-backend-service"
    protocol      = "HTTP"
    port_name     = "http"
  }
}

variable "web_map_name" {
  type = string
  default = "web-map"
}

variable "lb_proxy_name" {
  type = string
  default = "http-lb-proxy"
}
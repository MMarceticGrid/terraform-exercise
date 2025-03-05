variable "number_of_VMs" {
  type        = number
  description = "Number of VMs"
  default     = 2
}

variable "machine_type" {
  type        = string
  description = "Type of VM"
  default     = "f1-micro"
}

variable "vm_image" {
  type = string
}

variable "zone" {
  description = "The zone configuration"
  type        = string
}

variable "region" {
  description = "The region configuration"
  type        = string
}

variable "network_name" {
  type = string
}

variable "forwarding_rule" {
  type = map(object({
    name        = string
    port_range  = string
    ip_protocol = string
  }))
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
}

variable "instance_template" {
  type = map(object({
    name = string
    disk = object({
      auto_delete = bool
      boot        = bool
    })
  }))
}
variable "temp_compute_img_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "web_map_backend_service" {
  type = object({
    name = string
    protocol = string
    port_name = string
  })
}

variable "web_map_name" {
  type = string
}

variable "lb_proxy_name" {
  type = string
}
variable "number_of_VMs" {
  type        = number
  description = "Number of VMs"
  default     = 3
}

variable "machine_type" {
  type        = string
  description = "Type of VM"
  default     = "f1-micro"
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
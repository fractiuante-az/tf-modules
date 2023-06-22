variable "identifier" {}

variable "resource_group_name" {}

variable "location" {}

variable "network_config" {
  type = object({
    subnet_name          = string
    virtual_network_name = string
    resource_group_name  = optional(string)
  })
}

variable "vm_sku" {
  default = "Standard_B1ls"
}

variable "create_public_ip" {
  default = false
}

variable "dns_private_zone_name" {
  default = ""
}
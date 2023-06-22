# TODO: Make object optional
variable "vnet_config" {
  type = object({
    name                = string
    resource_group_name = optional(string)
    create              = bool
  })
}

variable "vpn_config" {
  type = object({
    tenant = optional(string, "5d3251b2-c53f-47e1-95c0-378922d5c244")
  })
}

variable "resource_group_name" {
  type = string
}

variable "ip_prefix_pool_address_spaces" {
  default = ["172.16.201.0/24"]
}

variable "location" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "gateway_subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "vpn_type" {
  description = "The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased"
  default     = "RouteBased"
}

variable "vpn_gw_sku" {
  description = "Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments"
  default     = "VpnGw1"
}

variable "vpn_gw_generation" {
  description = "The Generation of the Virtual Network gateway. Possible values include Generation1, Generation2 or None"
  default     = "Generation1"
}

variable "public_ip_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Dynamic"
  default     = "Dynamic"
}

variable "public_ip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic"
  default     = "Basic"
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "vpgn_gateway_get_credentials_aad_group_id" {
  default     = ""
  description = "Create and Asign Role to <vpgn_gateway_get_credentials_aad_group_id> to get VPN credentials"
}

locals {
  default_vnet_name = "vnet-${var.identifier}-main"
  vnet_name         = var.vnet_name_override == "" ? local.default_vnet_name : var.vnet_name_override
  subnet_count      = length(var.subnets)
}

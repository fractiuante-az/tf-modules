output "vnet_name" {
  value = local.vnet_name
}

output "vnet_cidr" {
  value = var.vnet_cidr
}

output "subnets" {
  value = local.subnet_count > 0 ? [for subnet in azurerm_subnet.subnets : {
    id               = subnet.id
    name             = subnet.name
    address_prefixes = subnet.address_prefixes
  }] : []
}

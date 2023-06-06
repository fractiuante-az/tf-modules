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

output "private_dns_zone_id" {
  value = var.private_dns_zone_name != "" ? data.azurerm_private_dns_zone.this.0.id : null
}

output "private_dns_zone_name" {
  value = var.private_dns_zone_name != "" ? data.azurerm_private_dns_zone.this.0.name : null
}
data "azurerm_private_dns_zone" "this" {
  count               = var.private_dns_zone_name != "" ? 1 : 0
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
}

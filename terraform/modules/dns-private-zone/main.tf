resource "azurerm_private_dns_zone" "this" {
  name                = var.domain
  resource_group_name = var.resource_group_name
  tags                = merge({ module = "dns-private-zone" }, var.tags)
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet" {
  count                 = var.link_virtual_network_id != "" ? 1 : 0
  name                  = "${var.identifier}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = var.link_virtual_network_id
  tags                  = merge({ module = "dns-private-zone" }, var.tags)
}

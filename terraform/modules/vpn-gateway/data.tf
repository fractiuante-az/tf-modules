data "azurerm_subnet" "existing" {
  count                = (var.vnet_config != null && var.vnet_config.create) ? 0 : 1
  name                 = "GatewaySubnet"
  virtual_network_name = var.vnet_config.name
  resource_group_name  = var.vnet_config.resource_group_name
}

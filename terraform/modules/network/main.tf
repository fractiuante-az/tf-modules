resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]
  tags = merge(
    {
      module = "network"
      name   = local.vnet_name
    },
  var.tags)
}


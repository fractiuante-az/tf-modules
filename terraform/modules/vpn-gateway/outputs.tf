output "network-peering" {
  description = "list of vnets to peer with Objects (name, resource_group)"
  value = var.vnet_config.create ? [
    {
      "name"                = azurerm_virtual_network.this.0.name,
      "resource_group_name" = azurerm_virtual_network.this.0.resource_group_name
    }
  ] : []
}

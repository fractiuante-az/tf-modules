data "azurerm_subnet" "existing" {
  depends_on           = [null_resource.depends_on_resources]
  name                 = var.network_config.subnet_name
  virtual_network_name = var.network_config.virtual_network_name
  resource_group_name  = var.network_config.resource_group_name != null ? var.network_config.resource_group_name : var.resource_group_name
}

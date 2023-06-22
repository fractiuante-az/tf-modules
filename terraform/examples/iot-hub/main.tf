resource "azurerm_resource_group" "this" {
  name     = lower("rg-${local.identifier}")
  location = var.location
}

module "iot-hub" {
  source              = "../../modules/iot-hub"
  identifier          = local.identifier
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

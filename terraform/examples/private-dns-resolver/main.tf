resource "azurerm_resource_group" "this" {
  name     = lower("rg-${local.identifier}")
  location = var.location
}

module "private-dns" {
  source              = "../../modules/private-dns-resolver"
  identifier          = local.identifier
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

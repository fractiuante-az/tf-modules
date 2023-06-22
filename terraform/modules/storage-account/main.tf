resource "random_integer" "random_id" {
  keepers = {
    resource_group = var.resource_group_name
    location       = var.location
  }
  min = 1
  max = 9999
  # byte_length = 4
}

resource "azurerm_storage_account" "this" {
  name = lower(replace(replace("${var.identifier}${random_integer.random_id.result}", "_", ""), "-", ""))

  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "containers" {
  for_each              = toset(var.containers)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

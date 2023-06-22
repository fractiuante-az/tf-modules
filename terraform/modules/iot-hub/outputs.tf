output "azurerm_iothub_name" {
  value = azurerm_iothub.iot_hub.name
}

output "azurerm_iothub_dps_name" {
  value = azurerm_iothub_dps.dps.name
}

output "resource_group_name" {
  value = var.resource_group_name
}

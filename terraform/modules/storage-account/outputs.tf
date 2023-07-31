output "primary_blob_endpoint" {
  value = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_blob_connection_string" {
  value = azurerm_storage_account.this.primary_blob_connection_string
}

output "primary_connection_string" {
  value = azurerm_storage_account.this.primary_connection_string
}

output "containers" {
  value = { for container_name in var.containers : container_name => azurerm_storage_container.containers[container_name] }
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = "db-${var.identifier}"

  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "12"
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  storage_mb             = 32768
  sku_name               = "GP_Standard_D4s_v3"

  private_dns_zone_id = var.private_dns_zone_id
  delegated_subnet_id = var.delegated_subnet_id

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? toset([var.maintenance_window]) : toset([])

    content {
      day_of_week  = lookup(maintenance_window.value, "day_of_week", 0)
      start_hour   = lookup(maintenance_window.value, "start_hour", 0)
      start_minute = lookup(maintenance_window.value, "start_minute", 0)
    }
  }


  #   dynamic "high_availability" {
  #     for_each = var.standby_zone != null && var.tier != "Burstable" ? toset([var.standby_zone]) : toset([])

  #     content {
  #       mode                      = "ZoneRedundant"
  #       standby_availability_zone = high_availability.value
  #     }
  #   }


  tags = merge({ module = "postgresql-flexible-server" }, var.tags)

  lifecycle {
    precondition {
      condition     = var.private_dns_zone_id != null && var.delegated_subnet_id != null || var.private_dns_zone_id == null && var.delegated_subnet_id == null
      error_message = "var.private_dns_zone_id and var.delegated_subnet_id should either both be set or none of them."
    }
    ignore_changes = [
      tags, zone
    ]
  }



}



# https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-extensions
resource "azurerm_postgresql_flexible_server_configuration" "azure_extensions" {
  count     = var.azure_extensions != null ? 1 : 0
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = var.azure_extensions
}


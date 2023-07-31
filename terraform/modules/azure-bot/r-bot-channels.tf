resource "azurerm_bot_channels_registration" "this" {
  depends_on = [ azurerm_bot_service_azure_bot.this ]
  name                = "bcr-${var.identifier}"
  location            = "global"
  resource_group_name = var.resource_group_name
  sku                 = "F0"
  microsoft_app_id    = var.microsoft_app_id != "" ? var.microsoft_app_id : data.azurerm_client_config.current.client_id
}

resource "azurerm_bot_channel_ms_teams" "this" {
  depends_on = [ azurerm_bot_channels_registration.this, azurerm_bot_service_azure_bot.this ]
  bot_name            = azurerm_bot_channels_registration.this.name
  location            = "global" #var.location
  resource_group_name = var.resource_group_name
}

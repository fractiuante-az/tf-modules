resource "azurerm_application_insights" "this" {
  name = "appinsights-${var.identifier}"

  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

resource "azurerm_application_insights_api_key" "this" {
  name                    = "appinsights-key-${var.identifier}"
  application_insights_id = azurerm_application_insights.this.id
  read_permissions        = ["aggregate", "api", "draft", "extendqueries", "search"]
}

resource "azurerm_bot_service_azure_bot" "this" {
  depends_on = [ azurerm_application_insights.this, azurerm_application_insights_api_key.this ]
  name                = "bot-${var.identifier}"
  location            = "global"
  resource_group_name = var.resource_group_name

  microsoft_app_id        = var.microsoft_app_id != "" ? var.microsoft_app_id : data.azurerm_client_config.current.client_id
  microsoft_app_type      = var.microsoft_app_type
  microsoft_app_tenant_id = var.microsoft_app_type == "MultiTenant" ? null : (var.microsoft_app_tenant_id != "" ? var.microsoft_app_tenant_id : data.azurerm_client_config.current.tenant_id)
  sku                     = "F0" # F0 or S1

  endpoint                              = var.bot_web_endpoint
  developer_app_insights_api_key        = azurerm_application_insights_api_key.this.api_key
  developer_app_insights_application_id = azurerm_application_insights.this.app_id

  tags = merge({ module = "linux-app-service" }, var.tags)
}

resource "azurerm_service_plan" "this" {
  name                = "app-svc-lnx-plan-${var.identifier}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "this" {
  depends_on          = [data.archive_file.linux_app_file_zip]
  name                = "app-svc-lnx-${var.identifier}"
  resource_group_name = var.resource_group_name
  location            = azurerm_service_plan.this.location
  service_plan_id     = azurerm_service_plan.this.id

  zip_deploy_file = data.archive_file.linux_app_file_zip.output_path
  app_settings = merge(var.app_env_vars, {
    WEBSITE_RUN_FROM_PACKAGE = 1
  })

  site_config {
    application_stack {
      node_version = "16-lts"
    }
    cors {
      allowed_origins = ["*"] # TODO: Teams
    }
  }

  logs {

  }

  tags = merge({ module = "linux-app-service" }, var.tags)

}

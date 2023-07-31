resource "azurerm_dns_txt_record" "domain-verification" {
  name                = "asuid.${local.hostname}"
  zone_name           = var.dns_config.zone_name
  resource_group_name = var.dns_config.resource_group_name
  ttl                 = 300

  record {
    value = azurerm_linux_web_app.this.custom_domain_verification_id
  }
}

resource "azurerm_dns_cname_record" "this" {
  depends_on          = [azurerm_dns_txt_record.domain-verification]
  name                = var.dns_config.subdomain
  zone_name           = var.dns_config.zone_name
  resource_group_name = var.dns_config.resource_group_name
  ttl                 = 300
  record              = azurerm_linux_web_app.this.default_hostname
}


resource "azurerm_app_service_custom_hostname_binding" "this" {
  hostname            = local.hostname
  app_service_name    = azurerm_linux_web_app.this.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_dns_cname_record.this]
}

resource "azurerm_app_service_managed_certificate" "this" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.this.id
}

resource "azurerm_app_service_certificate_binding" "this" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.this.id
  certificate_id      = azurerm_app_service_managed_certificate.this.id
  ssl_state           = "SniEnabled"
}

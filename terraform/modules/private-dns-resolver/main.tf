resource "azurerm_private_dns_resolver" "this" {
  name                = "example-resolver"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.vnet_id
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "example" {
  for_each                = { for subnet in var.endpoint_outbound_subnets : subnet.name => subnet }
  name                    = "${each.key}-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = azurerm_private_dns_resolver.this.location
  subnet_id               = each.value.id
  tags                    = merge({ module = "private-dns-resolver" }, var.tags)

}

resource "azurerm_private_dns_resolver_inbound_endpoint" "example" {
  for_each                = { for subnet in var.endpoint_inbound_subnets : subnet.name => subnet }
  name                    = "${each.key}-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = azurerm_private_dns_resolver.this.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id               = each.value.id
  }
  tags = merge({ module = "private-dns-resolver" }, var.tags)

}

# resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "this" {
#   name                                       = "example-ruleset"
#   resource_group_name                        = var.resource_group_name
#   location                                   = var.location
#   private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.example.id]
#   tags                                       = merge({ module = "private-dns-resolver" }, var.tags)

# }

# resource "azurerm_private_dns_resolver_forwarding_rule" "rp_internal_rule" {
#   name                      = "example-rule"
#   dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
#   domain_name               = "onprem.local."
#   enabled                   = true
#   target_dns_servers {
#     ip_address = "10.10.0.1"
#     port       = 53 # Fixed
#   }
#   metadata = {
#     key = "value"
#   }
# }

# resource "azurerm_private_dns_resolver_virtual_network_link" "example" {
#   name                      = "example-link"
#   dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
#   virtual_network_id        = azurerm_virtual_network.example.id
#   metadata = {
#     key = "value"
#   }
# }

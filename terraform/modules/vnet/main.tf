resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]
  tags = merge(
    {
      module = "network"
      name   = local.vnet_name
    },
  var.tags)
}

resource "azurerm_subnet" "subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.key
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  # Reverse exp2 function with log2 function and use ceil to break vnet into even sized subnets with maximum size possible
  address_prefixes                              = [cidrsubnet(var.vnet_cidr, ceil(log(local.subnet_count, 2)), index(var.subnets, each.value))]
  service_endpoints                             = each.value.service_endpoints
  private_link_service_network_policies_enabled = each.value.private_link
  private_endpoint_network_policies_enabled     = each.value.private_link
}


# --- Add VNETs to private DNS zone

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  count                 = var.private_dns_zone_name != "" ? 1 : 0
  name                  = "${local.vnet_name}-priv-dns-vnet-lnk"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.this.0.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

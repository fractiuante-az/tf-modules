resource "random_string" "str" {
  length  = 6
  special = false
  upper   = false
  keepers = {
    domain_name_label = var.name_prefix
  }
}

# TODO: Create if subnet_id null or ""
resource "azurerm_virtual_network" "this" {
  count               = (var.vnet_config != null && var.vnet_config.create) ? 1 : 0
  name                = var.vnet_config.name
  location            = var.location
  resource_group_name = (var.vnet_config.resource_group_name != null && var.vnet_config.resource_group_name != "") ? var.vnet_config.resource_group_name : var.resource_group_name
  address_space       = [var.gateway_subnet_cidr]
}

resource "azurerm_subnet" "this" {
  count                = (var.vnet_config != null && var.vnet_config.create) ? 1 : 0
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.this.0.name
  resource_group_name  = (var.vnet_config.resource_group_name != null && var.vnet_config.resource_group_name != "") ? var.vnet_config.resource_group_name : var.resource_group_name
  address_prefixes     = [var.gateway_subnet_cidr]
}

resource "azurerm_public_ip" "pip_gw" {
  name                = lower("${var.name_prefix}-gw-pip")
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  domain_name_label   = format("gw%s%s", lower(replace(var.name_prefix, "/[[:^alnum:]]/", "")), random_string.str.result)
  tags                = merge({ "Module" = "vpn-gateway" }, var.tags)
}


# "Borrowed" from this great repo: https://github.com/kumarvna/terraform-azurerm-vpn-gateway/blob/master/main.tf"
resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = "${var.name_prefix}-vpngw"
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = "Vpn"
  vpn_type            = var.vpn_type
  sku                 = var.vpn_gw_sku
  generation          = var.vpn_gw_generation
  active_active       = false
  enable_bgp          = false

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip_gw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = (var.vnet_config != null && var.vnet_config.create) ? azurerm_subnet.this.0.id : data.azurerm_subnet.existing.0.id
  }

  vpn_client_configuration {

    address_space        = var.ip_prefix_pool_address_spaces
    aad_tenant           = "https://login.microsoftonline.com/${var.vpn_config.tenant}"
    aad_audience         = "41b23e61-6c1e-4545-b367-cd054e0ed4b4" # Azure Public Cloud
    aad_issuer           = "https://sts.windows.net/${var.vpn_config.tenant}/"
    vpn_client_protocols = ["OpenVPN"] # - (Optional) List of the protocols supported by the vpn client. The supported values are SSTP, IkeV2 and OpenVPN. Values SSTP and IkeV2 are incompatible with the use of aad_tenant, aad_audience and aad_issuer.
    vpn_auth_types       = ["AAD"]     # AAD, Radius and Certificate
  }

  tags = merge({ "Module" = "vpn-gateway" }, var.tags)
}


# The vpn_client_configuration block supports:

# address_space - (Required) The address space out of which IP addresses for vpn clients will be taken. You can provide more than one address space, e.g. in CIDR notation.

# aad_tenant - (Optional) AzureAD Tenant URL

# aad_audience - (Optional) The client id of the Azure VPN application. See Create an Active Directory (AD) tenant for P2S OpenVPN protocol connections for values

# aad_issuer - (Optional) The STS url for your tenant

# root_certificate - (Optional) One or more root_certificate blocks which are defined below. These root certificates are used to sign the client certificate used by the VPN clients to connect to the gateway.

# revoked_certificate - (Optional) One or more revoked_certificate blocks which are defined below.

# radius_server_address - (Optional) The address of the Radius server.

# radius_server_secret - (Optional) The secret used by the Radius server.

# vpn_client_protocols - (Optional) List of the protocols supported by the vpn client. The supported values are SSTP, IkeV2 and OpenVPN. Values SSTP and IkeV2 are incompatible with the use of aad_tenant, aad_audience and aad_issuer.

# vpn_auth_types - (Optional) List of the vpn authentication types for the virtual network gateway. The supported values are AAD, Radius and Certificate.


# Microsoft.Network/p2sVpnGateways/read - Gets a P2SVpnGateway.
# Microsoft.Network/p2sVpnGateways/generatevpnprofile/action - Generate Vpn Profile for P2SVpnGateway.

# Roles for AD Group

resource "azurerm_role_definition" "vpgn_gateway_get_credentials" {
  count       = var.vpgn_gateway_get_credentials_aad_group_id != "" ? 1 : 0
  name        = "${var.name_prefix}-grp-vpn-get-credentials"
  scope       = azurerm_virtual_network_gateway.vpngw.id
  description = "Custom role created via Terraform to get vpn gateway credentials"

  permissions {
    actions     = ["Microsoft.Network/p2sVpnGateways/read", "Microsoft.Network/p2sVpnGateways/generatevpnprofile/action", "Microsoft.Network/virtualNetworkGateways/generatevpnprofile/action"]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_virtual_network_gateway.vpngw.id
  ]
}

resource "azurerm_role_assignment" "vpgn_gateway_get_credentials_aad" {
  count              = var.vpgn_gateway_get_credentials_aad_group_id != "" ? 1 : 0
  scope              = azurerm_virtual_network_gateway.vpngw.id
  role_definition_id = azurerm_role_definition.vpgn_gateway_get_credentials.0.role_definition_resource_id
  principal_id       = var.vpgn_gateway_get_credentials_aad_group_id
}

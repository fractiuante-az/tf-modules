resource "azurerm_resource_group" "this" {
  name     = lower("rg-${local.identifier}")
  location = var.location
}

module "azure_private_dns_zone" {
  source              = "../../modules/dns-private-zone"
  resource_group_name = azurerm_resource_group.this.name
  domain              = local.private_domain_name
}

module "azure_vnet" {
  source                = "../../modules/vnet"
  depends_on            = [azurerm_resource_group.this, module.azure_private_dns_zone]
  identifier            = local.identifier
  location              = var.location
  resource_group_name   = azurerm_resource_group.this.name
  vnet_cidr             = "10.1.0.0/16"
  private_dns_zone_name = module.azure_private_dns_zone.name
  subnets = concat([
    {
      name = "PrivateSubnet"
      type = "private"
    },
    {
      name = "PrivateSubnetB"
      type = "private"
    },
    {
      name = "GatewaySubnet"
      type = "private"
    }
  ], local.endpoint_subnets)
}

module "vpn_gateway" {
  source                                    = "../../modules/vpn-gateway"
  location                                  = var.location
  resource_group_name                       = azurerm_resource_group.this.name
  name_prefix                               = local.identifier
  gateway_subnet_cidr                       = module.azure_vnet.gateway_subnet_cidr
  ip_prefix_pool_address_spaces             = local.vpn_gateway_ip_prefix_pool_address_spaces
  vpgn_gateway_get_credentials_aad_group_id = var.aad_group_id_rpa_admin

  vnet_config = {
    name                = module.azure_vnet.vnet_name
    resource_group_name = module.azure_vnet.resource_group_name
    create              = false
  }

  vpn_config = {
    tenant = var.ARM_TENANT_ID
  }

  depends_on = [module.azure_vnet]
  tags       = {}
}


module "private-dns" {
  source                    = "../../modules/private-dns-resolver"
  identifier                = local.identifier
  location                  = var.location
  resource_group_name       = azurerm_resource_group.this.name
  vnet_id                   = module.azure_vnet.vnet_id
  endpoint_inbound_subnets  = [for subnet in local.endpoint_inbound_subnets : one([for subnet_out in module.azure_vnet.subnets : subnet_out if subnet.name == subnet_out.name])]
  endpoint_outbound_subnets = [for subnet in local.endpoint_outbound_subnets : one([for subnet_out in module.azure_vnet.subnets : subnet_out if subnet.name == subnet_out.name])]
}

module "vms" {
  # for_each = toset([])
  for_each              = toset(["1", "2"])

  source                = "../../modules/virtual-machine"
  depends_on            = [azurerm_resource_group.this, module.azure_vnet, module.azure_private_dns_zone]
  identifier            = "${local.identifier}-${each.key}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.this.name
  dns_private_zone_name = local.private_domain_name

  create_public_ip = true

  network_config = {
    subnet_name          = each.key % 2 == 0 ? "PrivateSubnet" : "PrivateSubnetB"
    virtual_network_name = module.azure_vnet.vnet_name
  }
}

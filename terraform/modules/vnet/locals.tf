locals {
  default_vnet_name = "vnet-${var.identifier}-main"
  vnet_name         = var.vnet_name_override == "" ? local.default_vnet_name : var.vnet_name_override
  subnet_count      = length(var.subnets)

  service_subnets               = [for subnet in var.subnets : subnet if !subnet.subnet_delegation && subnet.name != "GatewaySubnet"]
  vpn_subnets                   = [for subnet in var.subnets : subnet if subnet.subnet_delegation || subnet.name == "GatewaySubnet"]
  service_subnets_subnet_count  = length(local.service_subnets)
  vpn_subnets_subnet_count      = length(local.vpn_subnets)
  service_subnet_cidr_range     = local.vpn_subnets_subnet_count > 0 ? cidrsubnet(var.vnet_cidr, 1, 0) : var.vnet_cidr
  vpn_subnets_subnet_cidr_range = local.vpn_subnets_subnet_count > 0 ? cidrsubnet(var.vnet_cidr, 1, 1) : var.vnet_cidr

  gateway_subnet_cidr = one([for subnet in local.vpn_subnets : subnet if subnet.name == "GatewaySubnet"])

  dns_resolver_subnets_delegation = {
    "Microsoft.Network.dnsResolvers" = [
      {
        name    = "Microsoft.Network/dnsResolvers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    ]
  }

}

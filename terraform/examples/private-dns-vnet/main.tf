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
  depends_on            = [module.azure_private_dns_zone]
  identifier            = local.identifier
  location              = var.location
  resource_group_name   = azurerm_resource_group.this.name
  vnet_cidr             = "10.1.0.0/16"
  private_dns_zone_name = module.azure_private_dns_zone.name
  subnets = [{
    name = "PrivateSubnet"
    type = "private"
  }]
}

module "vms" {
  for_each              = toset(["1", "2"])
  source                = "../../modules/virtual-machine"
  identifier            = "${local.identifier}-${each.key}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.this.name
  dns_private_zone_name = local.private_domain_name

  create_public_ip = true

  network_config = {
    subnet_name          = "PrivateSubnet"
    virtual_network_name = module.azure_vnet.vnet_name
  }
}

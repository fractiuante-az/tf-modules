module "azure_private_dns_zone" {
  source                  = "../../modules/dns-private-zone"
  identifier              = local.identifier
  resource_group_name     = local.resource_group_name
  domain                  = local.private_domain_name
  link_virtual_network_id = data.azurerm_virtual_network.vnet.id
  tags                    = local.tags

}

module "postgresql_flexible_server" {
  source                 = "../../modules/postgresql-flexible-server"
  identifier             = "example-psql-flex-1"
  location               = "Germany West Central"
  resource_group_name    = local.resource_group_name
  private_dns_zone_id    = module.azure_private_dns_zone.id
  delegated_subnet_id    = data.azurerm_subnet.cluster_subnet.id
  depends_on             = [module.azure_private_dns_zone]
  administrator_login    = "psqladmin"
  administrator_password = "H@Sh1CoR3!"
  tags                   = local.tags
}

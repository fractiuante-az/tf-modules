data "azurerm_subnet" "cluster_subnet" {
  name                 = "database-subnet"
  virtual_network_name = "vnet-dev-pgres-flex-gwc"
  resource_group_name  = "rg-dev-aks"
}

data "azurerm_virtual_network" "vnet" {
    name ="vnet-dev-pgres-flex-gwc"
    resource_group_name = "rg-dev-aks"
  
}
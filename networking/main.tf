resource "azurerm_resource_group" "bestrong-rg" {
  name     = "bestrong-rg"
  location = "westus2"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.bestrong-rg.location
  resource_group_name = azurerm_resource_group.bestrong-rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "app-subnet" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.bestrong-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "regular-subnet" {
  name                 = "regular-subnet"
  resource_group_name  = azurerm_resource_group.bestrong-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.KeyVault"]

  private_endpoint_network_policies_enabled = true
}
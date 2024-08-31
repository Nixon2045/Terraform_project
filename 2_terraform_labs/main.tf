terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features{}
}

resource "azurerm_resource_group" "Demo1" {
  name     = "demo1"
  location = "West Europe"
}


resource "azurerm_virtual_network" "vnet1" {
  name                = "prueba_vnet"
  location            = azurerm_resource_group.Demo1.location
  resource_group_name = azurerm_resource_group.Demo1.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Production"
  }
} 

resource "azurerm_subnet" "subnet1" {
    name           = "subnet1"
    resource_group_name = azurerm_resource_group.Demo1.name
    virtual_network_name = azurerm_virtual_network.vnet1.name
    address_prefixes = ["10.0.1.0/24"]
  }
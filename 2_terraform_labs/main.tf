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


resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  location            = azurerm_resource_group.Demo1.location
  resource_group_name = azurerm_resource_group.Demo1.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  tags = {
    environment = "Production"
  }
}
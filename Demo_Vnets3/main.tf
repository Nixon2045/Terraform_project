terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.11.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "principal04" {
  name = var.rg_name
  location = var.rg_location
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"

  resource_group_name = var.rg_name
  use_for_each        = false
  address_space = [var.vnet_cidr_range]
  subnet_names = var.subnet_names
  subnet_prefixes = var.subnet_prefixes
  vnet_name = var.vnet_name
  vnet_location = var.rg_location
  tags = {
    enviroment = "dev"
  }

  depends_on = [azurerm_resource_group.principal04]



}
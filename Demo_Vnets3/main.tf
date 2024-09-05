terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  provider{}
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"  
}
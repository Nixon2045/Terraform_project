terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }
}

provider "azurerm" {
    features {} 
}

resource random_integer rn {
  min = 10000
  max = 99999
}


resource "azurerm_resource_group" "Demo04" {
    name        = var.rg_name
    location    = var.rg_location
}

resource "azurerm_storage_account" "sa" {
    
} 
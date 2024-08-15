terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.115.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "pruebita-example" {
  name = "example-resource-group"
  location = "west europe"
}


#configuracion de dependencia implicita

resource "azurerm_resource_group" "Rg2" {
  name = "Rg2"
  location = "west europe"
  tags = {
    dependency = azurerm_resource_group.pruebita-example.name
  }
}
#configuracion de dependencia explicita
resource "azurerm_resource_group" "Rg3" {
  name = "Rg3"
  location = "west europe"
  depends_on = [
    azurerm_resource_group.Rg2
  ]
}
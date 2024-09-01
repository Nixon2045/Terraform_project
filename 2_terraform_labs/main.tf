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
  features{}
}

/* Clase 32 - Creando una red virtual 

Para crear una vnet o red virtual en azure primero se necesita crear un grupo de recursos donde se instalara 
la vnet, asi que primero se crea el grupo de recursos "Demo1" para que haga de esta funcion.
Se crean luego dos bloques de recursos, una que sera la red virtual y tendra por nombre "vnet1"
que tendra que tener unos argumentos requeridos para poder crearse como recurso como es address_space que es un rango de IP's 
que pueden ser asignadas con este rango.
Luego sigue el siguiente bloque donde se especifica la subnet o subred  
que debera definirse source_group_name para especificar a que grupo de recursos va ser asignada la subnet
y tambien virtual_network_name para definit a que red virtual pertecera la subred 
y address_prefixes define el rango de ip que estara disponible para la subred
*/

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
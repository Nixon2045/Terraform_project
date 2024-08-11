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
  alias = "prueba"
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_id  
}


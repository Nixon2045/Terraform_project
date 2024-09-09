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
    name = ${lower(var.naming_prefix)${random_integer.rn.result}}
    location = var.rg_location
    acoount_tier = "standard"
    resource_group_name = var.rg_name
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
    name = "terraform_state"
    storage_account_name = azurerm_storage_account.sa.name
}

data "azurerm_storage_account.sas" "sas" {
    connection_string = azurerm_storage_account.sa.primary_connection_string
    https_only = true
    resource_types = {
        service = true
        container = true
        object = true
    }
    start = timestamp()
    expire = timeadd(timestamp(), "17000h")
    services {
        blob = true
        queue = false
        table = false
        file = false
    }
}
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
    name = "${lower(var.naming_prefix)}${random_integer.rn.result}"
    location = var.rg_location
    resource_group_name = var.rg_name
    account_replication_type = "LRS"
    account_tier = "standard"
}

resource "azurerm_storage_container" "container" {
    name = "terraform_state"
    storage_account_name = azurerm_storage_account.sa.name
}

data "azurerm_storage_account_sas" "sas" {
    connection_string = azurerm_storage_account.sa.primary_connection_string
    https_only = true
    resource_types = {
        service = true
        container = true
        object = true
    }
    start = timestamp()
    expiry   = timeadd(timestamp(), "17000h")
    services {
        blob = true
        queue = false
        table = false
        file = false
    }
}

resource "local_file" "post_config" {
        depends_on = [azurerm_storage_container.container]
        filename = "${path.module}/backend-config.txt"
        content = <<EOF
        storage_account_name = "${azurerm_storage_account.sa.name}"
        container_name = "terraform-state"
        key = "terraform.tfstate"
        sas_token = "${data.azurerm_storage_account_sas.sas.sas}"



        EOF
}
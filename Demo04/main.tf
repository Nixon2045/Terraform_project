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
    subscription_id = "647ea278-4ab3-46fc-9478-0b4943458b45"
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
    resource_group_name = azurerm_resource_group.Demo04.name
    account_replication_type = "LRS"
    account_tier = "Standard"
}

resource "azurerm_storage_container" "container" {
    name = "terraform-state"
    storage_account_name = azurerm_storage_account.sa.name
}

data "azurerm_storage_account_sas" "sas" {
    connection_string = azurerm_storage_account.sa.primary_connection_string
    https_only = true
    start = timestamp()
    expiry   = timeadd(timestamp(), "17000h")
  permissions {
    add     = true
    create  = true
    delete  = true
    filter  = true
    list    = true
    process = false
    read    = true
    tag     = true
    update  = false
    write   = true
  }
    resource_types {
        service = true
        container = true
        object = true
    }
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
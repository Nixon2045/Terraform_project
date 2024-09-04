
resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet_name
  location            = var.Rg_location
  resource_group_name = var.Rg_name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Production"
  }
}


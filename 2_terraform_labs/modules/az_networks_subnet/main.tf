
resource "azurerm_subnet" "subnet1" {
    name           = "subnet1"
    resource_group_name = var.gruop_name_subnet
    virtual_network_name = var.vnet_name
    address_prefixes = ["10.0.1.0/24"]
  }
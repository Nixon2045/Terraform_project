

output "prueba_id" {
  value = azurerm_resource_group.Demo1.id
}

output "prueba_location" {
  value = azurerm_virtual_network.vnet1.location
}
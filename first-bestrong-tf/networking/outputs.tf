output "resource-group-name" {
  value = azurerm_resource_group.bestrong-rg.name
}

output "resource-group-location" {
  value = azurerm_resource_group.bestrong-rg.location
}

output "regular-subnet-id" {
  value = azurerm_subnet.regular-subnet.id
}

output "app-subnet-id" {
  value = azurerm_subnet.app-subnet.id
}
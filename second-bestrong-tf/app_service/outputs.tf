output "app-service-smi-id" {
  value = azurerm_app_service.bestrongwebapp.identity[0].principal_id
}

output "resource-group-name" {
  value = azurerm_resource_group.bestrong-rg.name
}

output "resource-group-location" {
  value = azurerm_resource_group.bestrong-rg.location
}
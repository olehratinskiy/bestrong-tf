resource "azurerm_container_registry" "exampleacror13" {
  name                = "exampleacror13"
  resource_group_name = var.resource-group-name
  location            = var.resource-group-location
  sku                 = "Basic"
}

resource "azurerm_role_assignment" "acr-role-assignment" {
  scope                = azurerm_container_registry.exampleacror13.id
  role_definition_name = "AcrPull"
  principal_id         = var.app-service-smi-id
}
resource "azurerm_container_registry" "exampleacror13" {
  name                = "exampleacror13"
  resource_group_name = var.resource-group-name
  location            = var.resource-group-location
  sku                 = "Basic"
}

resource "azurerm_key_vault" "examplekvor13" {
  name                = "examplekvor13"
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
  sku_name            = "standard"
  tenant_id           = var.tenant-id

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.regular-subnet-id]
  }
}

resource "azurerm_role_assignment" "acr-role-assignment" {
  scope                = azurerm_container_registry.exampleacror13.id
  role_definition_name = "AcrPull"
  principal_id         = var.app-service-smi-id
}

resource "azurerm_role_assignment" "kv-role-assignment" {
  scope                = azurerm_key_vault.examplekvor13.id
  role_definition_name = "Key Vault Contributor"
  principal_id         = var.app-service-smi-id
}
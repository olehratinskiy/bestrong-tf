resource "azurerm_resource_group" "bestrong-rg" {
  name     = "bestrong-rg"
  location = "westus2"
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "appserviceplan"
  location            = azurerm_resource_group.bestrong-rg.location
  resource_group_name = azurerm_resource_group.bestrong-rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "bestrongwebapp" {
  name                = "bestrongwebapp"
  resource_group_name = azurerm_resource_group.bestrong-rg.name
  location            = azurerm_app_service_plan.appserviceplan.location
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|nginx"
    acr_use_managed_identity_credentials = true
  }

  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_service_plan" "appserviceplan" {
  name                = "appserviceplan"
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "bestrongwebapp" {
  name                = "bestrongwebapp"
  resource_group_name = var.resource-group-name
  location            = azurerm_service_plan.appserviceplan.location
  service_plan_id     = azurerm_service_plan.appserviceplan.id

  site_config {}

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.app_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.app_insights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }

  storage_account {
    access_key   = var.storage-account-access-key
    account_name = var.storage-account-name
    name         = "fileshare"
    share_name   = "fileshare"
    type         = "AzureFiles"
    mount_path   = "/fileshare"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "webapp-vnet-integration" {
  app_service_id = azurerm_linux_web_app.bestrongwebapp.id
  subnet_id      = var.app-subnet-id
}

resource "azurerm_log_analytics_workspace" "loganalytics-workspace" {
  name                = "loganalytics-workspace"
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
  sku                 = "PerGB2018"
}

resource "azurerm_application_insights" "app_insights" {
  name                = "app_insights"
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
  workspace_id        = azurerm_log_analytics_workspace.loganalytics-workspace.id
  application_type    = "other"
}
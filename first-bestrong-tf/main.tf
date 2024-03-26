terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "state-rg"
    storage_account_name = "terraformstorageo"
    container_name       = "state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}


data "azurerm_client_config" "current" {}

module "networking" {
  source = "./networking/"
}

module "database_and_storage" {
  source                  = "./database_and_storage/"
  resource-group-name     = module.networking.resource-group-name
  resource-group-location = module.networking.resource-group-location
  regular-subnet-id       = module.networking.regular-subnet-id
  mssql_server_login      = var.mssql_server_login
  mssql_server_password   = var.mssql_server_password
}

module "app_service_and_monitoring" {
  source                     = "./app_service_and_monitoring/"
  app-subnet-id              = module.networking.app-subnet-id
  resource-group-name        = module.networking.resource-group-name
  resource-group-location    = module.networking.resource-group-location
  storage-account-access-key = module.database_and_storage.storage-account-access-key
  storage-account-name       = module.database_and_storage.storage-account-name

  depends_on = [
    module.networking,
    module.database_and_storage
  ]
}

module "containerization_and_secrets" {
  source                  = "./containerization_and_secrets/"
  resource-group-name     = module.networking.resource-group-name
  resource-group-location = module.networking.resource-group-location
  regular-subnet-id       = module.networking.regular-subnet-id
  app-service-smi-id      = module.app_service_and_monitoring.app-service-smi-id
  tenant-id               = data.azurerm_client_config.current.tenant_id

  depends_on = [
    module.networking,
    module.app_service_and_monitoring
  ]
}
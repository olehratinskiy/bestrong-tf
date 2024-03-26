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


module "app_service" {
  source = "./app_service/"
}

module "containerization" {
  source                  = "./containerization/"
  resource-group-name     = module.app_service.resource-group-name
  resource-group-location = module.app_service.resource-group-location
  app-service-smi-id      = module.app_service.app-service-smi-id
  tenant-id               = data.azurerm_client_config.current.tenant_id

  depends_on = [
    module.app_service
  ]
}

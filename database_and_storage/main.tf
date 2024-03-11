resource "azurerm_mssql_server" "example-mssql-server-or13" {
  name                         = "example-mssql-server-or13"
  resource_group_name          = var.resource-group-name
  location                     = var.resource-group-location
  version                      = "12.0"
  administrator_login          = var.mssql_server_login
  administrator_login_password = var.mssql_server_password
}

resource "azurerm_private_endpoint" "mssql-private-endpoint" {
  name                = "mssql-private-endpoint"
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
  subnet_id           = var.regular-subnet-id

  depends_on = [azurerm_mssql_server.example-mssql-server-or13]

  private_service_connection {
    name                           = "mssql-server-connection"
    private_connection_resource_id = azurerm_mssql_server.example-mssql-server-or13.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_storage_account" "storageaccount32413" {
  name                     = "storageaccount32413"
  resource_group_name      = var.resource-group-name
  location                 = var.resource-group-location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_private_endpoint" "storage-account-private-endpoint" {
  name                = "storage-account-private-endpoint"
  location            = var.resource-group-location
  resource_group_name = var.resource-group-name
  subnet_id           = var.regular-subnet-id

  depends_on = [azurerm_storage_account.storageaccount32413]

  private_service_connection {
    name                           = "storage-account-connection"
    private_connection_resource_id = azurerm_storage_account.storageaccount32413.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}
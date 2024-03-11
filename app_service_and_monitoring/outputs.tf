output "app-service-smi-id" {
  value = azurerm_linux_web_app.bestrongwebapp.identity[0].principal_id
}
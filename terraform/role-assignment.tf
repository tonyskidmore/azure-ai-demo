resource "azurerm_role_assignment" "acr" {
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
  principal_id         = azurerm_linux_web_app.application.identity[0].principal_id
}
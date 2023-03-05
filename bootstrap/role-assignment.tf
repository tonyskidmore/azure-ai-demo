resource "azurerm_role_assignment" "demo-rg" {
  role_definition_name = "User Access Administrator"
  scope                = azurerm_resource_group.demo.id
  principal_id         = data.azuread_service_principal.service-principal.object_id
}
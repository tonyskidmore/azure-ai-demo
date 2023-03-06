resource "azurerm_role_assignment" "demo-rg-uac" {
  role_definition_name = "User Access Administrator"
  scope                = azurerm_resource_group.demo.id
  principal_id         = data.azuread_service_principal.service-principal.object_id
}

resource "azurerm_role_assignment" "demo-rg-cont" {
  role_definition_name = "Contributor"
  scope                = azurerm_resource_group.demo.id
  principal_id         = data.azuread_service_principal.service-principal.object_id
}

# resource "azurerm_role_assignment" "demo-rg-uac" {
#   role_definition_name = "User Access Administrator"
#   scope                = azurerm_resource_group.demo.id
#   // principal_id         = data.azuread_service_principal.service-principal.object_id
#   principal_id         = "e4257170-8c57-4bf3-bf9b-d2e1e8e73b1d"
# }

# resource "azurerm_role_assignment" "demo-rg-cont" {
#   role_definition_name = "Contributor"
#   scope                = azurerm_resource_group.demo.id
#   // principal_id         = data.azuread_service_principal.service-principal.object_id
#   principal_id         = "e4257170-8c57-4bf3-bf9b-d2e1e8e73b1d"
# }

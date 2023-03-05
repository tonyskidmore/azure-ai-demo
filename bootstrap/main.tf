resource "azurerm_resource_group" "azure-ai-demo" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# resource "azurerm_management_lock" "resource-group-level" {
#   name       = "resource-group-level"
#   scope      = azurerm_resource_group.azure-ai-demo.id
#   lock_level = "CanNotDelete"
#   notes      = "This would normally be set if not a demo"
# }

resource "azurerm_resource_group" "demo" {
  name     = var.demo_resource_group_name
  location = var.location
  tags     = var.tags
}

data "azuread_service_principal" "service-principal" {
  application_id = var.serviceprincipalid
}

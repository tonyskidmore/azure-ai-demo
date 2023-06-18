# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/search_service

resource "azurerm_search_service" "example" {
  name                = "example-resource"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard"

  local_authentication_enabled = true
  authentication_failure_mode  = "http403"
}

# privatelink.search.windows.net


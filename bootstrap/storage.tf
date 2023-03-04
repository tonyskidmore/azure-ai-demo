resource "azurerm_storage_account" "azure-ai-demo" {
  name                          = "sademoai${random_string.build_index.result}"
  resource_group_name           = azurerm_resource_group.azure-ai-demo.name
  location                      = azurerm_resource_group.azure-ai-demo.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = true

  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.azure-ai-demo.name
  container_access_type = "private"
}

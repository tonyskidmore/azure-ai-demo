resource "azurerm_storage_account" "azure-ai-demo" {
  name                            = "sademoai${random_string.build_index.result}"
  resource_group_name             = azurerm_resource_group.azure-ai-demo.name
  location                        = azurerm_resource_group.azure-ai-demo.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  logging {
    delete                = true
    read                  = true
    write                 = true
    version               = "1.0"
    retention_policy_days = 10
  }
  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.azure-ai-demo.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "azure-ai-demo" {
  name                            = "sademoai${random_string.build_index.result}"
  resource_group_name             = azurerm_resource_group.azure-ai-demo.name
  location                        = azurerm_resource_group.azure-ai-demo.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = true
  # allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  # Blocks of type "logging" are not expected here
  # logging {
  #   delete                = true
  #   read                  = true
  #   write                 = true
  #   version               = "1.0"
  #   retention_policy_days = 10
  # }
  tags = var.tags
}

# │ Error: containers.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:9458fc7a-301e-0064-3384-602a85000000\nTime:2023-03-27T08:14:57.0848120Z"
# │
# │   with azurerm_storage_container.tfstate,
# │   on storage.tf line 21, in resource "azurerm_storage_container" "tfstate":
# │   21: resource "azurerm_storage_container" "tfstate" {
# │
# ╵

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.azure-ai-demo.name
  container_access_type = "private"
}

resource "azurerm_key_vault" "application" {
  name                       = "kv${var.key_vault_name}${random_string.build_index.result}"
  resource_group_name        = data.azurerm_resource_group.ai-demo.name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  sku_name                   = "standard"
  # Status=403 Code="Forbidden" Message="Connection is not an approved private link and caller was ignored because bypass is not set to 'AzureServices' and PublicNetworkAccess is set to 'Disabled'.
  public_network_access_enabled = false

  purge_protection_enabled = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    # virtual_network_subnet_ids = data.azurerm_virtual_network.bootstrap.
  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "app" {
  key_vault_id = azurerm_key_vault.application.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.application.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_access_policy" "sp" {
  key_vault_id = azurerm_key_vault.application.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Delete",
    "Purge",
    "Set",
    "Backup",
    "Recover",
    "Restore"
  ]
}

resource "azurerm_private_dns_zone" "kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_resource_group.ai-demo.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv" {
  name                  = azurerm_key_vault.application.name
  resource_group_name   = data.azurerm_resource_group.ai-demo.name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = data.azurerm_virtual_network.bootstrap.id

  tags = var.tags
}

resource "azurerm_private_endpoint" "kv" {
  name                = "pe-${var.acr_name}-kv"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.ai-demo.name
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv.id]
  }

  private_service_connection {
    name                           = azurerm_key_vault.application.name
    private_connection_resource_id = azurerm_key_vault.application.id
    subresource_names              = ["Vault"]
    is_manual_connection           = false
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "openai" {
  name            = "openai-api-key"
  value           = var.openai_api_key
  key_vault_id    = azurerm_key_vault.application.id
  expiration_date = local.secret_expiry_date
  content_type    = "text/plain"

  depends_on = [
    azurerm_private_endpoint.kv,
    azurerm_key_vault_access_policy.sp
  ]
}

resource "azurerm_key_vault_secret" "cogkey" {
  name            = "cog-service-key"
  value           = azurerm_cognitive_account.translate.primary_access_key
  key_vault_id    = azurerm_key_vault.application.id
  expiration_date = local.secret_expiry_date
  content_type    = "text/plain"

  depends_on = [
    azurerm_private_endpoint.kv,
    azurerm_key_vault_access_policy.sp
  ]
}

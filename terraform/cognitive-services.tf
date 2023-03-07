resource "azurerm_cognitive_account" "translate" {
  name                               = "cs${var.cognitive_account_name}${random_string.build_index.result}"
  location                           = var.location
  resource_group_name                = data.azurerm_resource_group.ai-demo.name
  kind                               = var.cognitive_kind
  sku_name                           = var.cognitive_sku
  custom_subdomain_name              = cognitive_private_link ? "cs${var.cognitive_custom_subdomain}${random_string.build_index.result}" : null
  outbound_network_access_restricted = true
  public_network_access_enabled      = false

  identity {
    type = "SystemAssigned"
  }

  #   network_acls {
  #     default_action = "Allow"
  #   }
}

resource "azurerm_private_dns_zone" "cs" {
  count               = cognitive_private_link ? 1 : 0
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = data.azurerm_resource_group.ai-demo.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cs" {
  count                 = cognitive_private_link ? 1 : 0
  name                  = azurerm_cognitive_account.translate.name
  resource_group_name   = data.azurerm_resource_group.ai-demo.name
  private_dns_zone_name = azurerm_private_dns_zone.cs.name
  virtual_network_id    = data.azurerm_virtual_network.bootstrap.id

  tags = var.tags
}

resource "azurerm_private_endpoint" "cs" {
  count               = cognitive_private_link ? 1 : 0
  name                = "pe-${var.cognitive_account_name}-cs"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.ai-demo.name
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.cs[0].id]
  }

  private_service_connection {
    name                           = azurerm_cognitive_account.translate.name
    private_connection_resource_id = azurerm_cognitive_account.translate.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }
}

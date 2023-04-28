resource "azurerm_cognitive_account" "translate" {
  name                               = "cs${var.cognitive_account_name}${random_string.build_index.result}"
  location                           = var.location
  resource_group_name                = data.azurerm_resource_group.ai-demo.name
  kind                               = var.cognitive_kind
  sku_name                           = var.cognitive_sku
  custom_subdomain_name              = var.cognitive_private_link ? "cs${var.cognitive_custom_subdomain}${random_string.build_index.result}" : null
  outbound_network_access_restricted = var.cognitive_private_link ? false : true
  public_network_access_enabled      = var.cognitive_private_link ? false : true

  identity {
    type = "SystemAssigned"
  }

  # https://learn.microsoft.com/en-us/azure/cognitive-services/cognitive-services-virtual-networks?tabs=portal
  # https://github.com/hashicorp/terraform-provider-azurerm/blob/d3457931feca7bf3abdda344f50c86f7934b1bbd/internal/services/cognitive/cognitive_account_resource_test.go#L889-L906
  # network_acls {
  #   default_action = "Deny"
  #   ip_rules       = []
  #   virtual_network_rules {
  #     subnet_id = data.azurerm_subnet.vnet_integration.id
  #   }
  # }

  # depends_on = [
  #   time_sleep.wait_for_dns
  # ]

}

resource "azurerm_private_dns_zone" "cs" {
  count               = var.cognitive_private_link ? 1 : 0
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = data.azurerm_resource_group.ai-demo.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cs" {
  count                 = var.cognitive_private_link ? 1 : 0
  name                  = azurerm_cognitive_account.translate.name
  resource_group_name   = data.azurerm_resource_group.ai-demo.name
  private_dns_zone_name = azurerm_private_dns_zone.cs[0].name
  virtual_network_id    = data.azurerm_virtual_network.bootstrap.id

  tags = var.tags
}

resource "azurerm_private_endpoint" "cs" {
  count               = var.cognitive_private_link ? 1 : 0
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

resource "azurerm_cognitive_account" "svc" {
  for_each                           = var.cognitive_services
  name                               = "cs${each.value.name}${random_string.build_index.result}"
  location                           = each.value.location == null ? var.location : each.value.location
  resource_group_name                = data.azurerm_resource_group.ai-demo.name
  kind                               = each.value.kind
  sku_name                           = each.value.sku_name
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
  # count               = var.cognitive_private_link ? 1 : 0
  for_each = toset(local.private_dns_zones)
  # for_each = { for svc in var.cognitive_services : svc.name => svc }
  # TODO: lookup private dns zone from locals based on kind
  # name                = lookup(local.cog_svc_private_dns_zone_lookup, each.value.kind, null)
  name                = each.value
  resource_group_name = data.azurerm_resource_group.ai-demo.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cs" {
  # count                 = var.cognitive_private_link ? 1 : 0
  # for_each              = local.private_dns_zones
  for_each              = azurerm_private_dns_zone.cs
  name                  = each.value.name
  resource_group_name   = data.azurerm_resource_group.ai-demo.name
  private_dns_zone_name = each.value.name
  virtual_network_id    = data.azurerm_virtual_network.bootstrap.id

  tags = var.tags
}

resource "azurerm_private_endpoint" "cs" {
  # count               = var.cognitive_private_link ? 1 : 0
  for_each            = azurerm_cognitive_account.svc
  name                = "pe-${each.value.name}-cs"
  location            = each.value.location == null ? var.location : each.value.location
  resource_group_name = data.azurerm_resource_group.ai-demo.name
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  private_dns_zone_group {
    name = "${each.value.name}-private-dns-zone-group"
    # private_dns_zone_ids = [azurerm_private_dns_zone.cs[each.value.kind].id]
    private_dns_zone_ids = [azurerm_private_dns_zone.cs[lookup(local.cog_svc_private_dns_zone_lookup, each.value.kind, null)].id]
  }

  private_service_connection {
    name                           = each.value.name
    private_connection_resource_id = each.value.id
    # https://learn.microsoft.com/en-gb/azure/private-link/private-endpoint-overview#private-link-resource
    subresource_names    = ["account"]
    is_manual_connection = false
  }
}

# https://github.com/shsorot/TerraformMonkeyWorks/blob/c7ebb44e51e830da1f58b053b29c44cd0607a9df/AzureRM/Modules/Network/Azure-PrivateEndpoint/1.0/azurerm_private_endpoint.tf#L2
# https://github.com/briandenicola/azure/blob/1594d36da7a25b6343a2435a0a3b8c0a49b2b791/Templates/AzureRedisCache/Enterprise/redis.tf#L2

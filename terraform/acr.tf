resource "azurerm_container_registry" "acr" {
  name                          = "cr${var.acr_name}${random_string.build_index.result}"
  resource_group_name           = data.azurerm_resource_group.ai-demo.name
  location                      = var.location
  sku                           = "Premium"
  admin_enabled                 = var.acr_admin_enabled
  public_network_access_enabled = false

  identity {
    type         = var.acr_identity_type
    identity_ids = var.acr_identity_ids
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone" "acr" {
  name                = "azurecr.io"
  resource_group_name = data.azurerm_resource_group.ai-demo.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                  = azurerm_container_registry.acr.name
  resource_group_name   = data.azurerm_resource_group.ai-demo.name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = data.azurerm_virtual_network.bootstrap.id

  tags = var.tags
}


resource "azurerm_private_endpoint" "acr" {
  name                = "pe-${var.acr_name}-acr"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.ai-demo.name
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr.id]
  }

  private_service_connection {
    name                           = azurerm_container_registry.acr.name
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  tags = var.tags
}
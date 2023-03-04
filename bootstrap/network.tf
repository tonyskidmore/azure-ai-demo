resource "azurerm_virtual_network" "azure-ai-demo" {
  name                = var.vmss_vnet_name
  resource_group_name = azurerm_resource_group.azure-ai-demo.name
  address_space       = var.vmss_vnet_address_space
  location            = azurerm_resource_group.azure-ai-demo.location
  tags                = var.tags
}

resource "azurerm_subnet" "azure-ai-demo" {
  name                 = var.vmss_subnet_name
  resource_group_name  = azurerm_resource_group.azure-ai-demo.name
  address_prefixes     = var.vmss_subnet_address_prefixes
  virtual_network_name = azurerm_virtual_network.azure-ai-demo.name
}

resource "azurerm_network_security_group" "azure-ai-demo" {
  name                = var.nsg_name
  location            = azurerm_resource_group.azure-ai-demo.location
  resource_group_name = azurerm_resource_group.azure-ai-demo.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "azure-ai-demo" {
  subnet_id                 = azurerm_subnet.azure-ai-demo.id
  network_security_group_id = azurerm_network_security_group.azure-ai-demo.id
}

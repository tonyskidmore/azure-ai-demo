# resource "azurerm_virtual_network" "azure-ai-demo" {
#   name                = var.vmss_vnet_name
#   resource_group_name = azurerm_resource_group.azure-ai-demo.name
#   address_space       = var.vnet_address_space
#   location            = azurerm_resource_group.azure-ai-demo.location
#   tags                = var.tags
# }

# resource "azurerm_subnet" "azure-ai-demo-vmss" {
#   name                 = var.vmss_subnet_name
#   resource_group_name  = azurerm_resource_group.azure-ai-demo.name
#   address_prefixes     = var.vmss_subnet_address_prefixes
#   virtual_network_name = azurerm_virtual_network.azure-ai-demo.name
# }

# resource "azurerm_subnet" "azure-ai-demo-vnet-int" {
#   name                 = var.vmss_subnet_name
#   resource_group_name  = azurerm_resource_group.azure-ai-demo.name
#   address_prefixes     = var.vmss_subnet_address_prefixes
#   virtual_network_name = azurerm_virtual_network.azure-ai-demo.name
# }

# resource "azurerm_network_security_group" "azure-ai-demo" {
#   name                = var.nsg_name
#   location            = azurerm_resource_group.azure-ai-demo.location
#   resource_group_name = azurerm_resource_group.azure-ai-demo.name
#   tags                = var.tags
# }

# resource "azurerm_subnet_network_security_group_association" "azure-ai-demo" {
#   subnet_id                 = azurerm_subnet.azure-ai-demo.id
#   network_security_group_id = azurerm_network_security_group.azure-ai-demo.id
# }

module "network" {
  source                  = "Azure/network/azurerm"
  version                 = "5.2.0"
  resource_group_name     = azurerm_resource_group.azure-ai-demo.name
  resource_group_location = azurerm_resource_group.azure-ai-demo.location
  address_spaces          = var.vnet_address_space
  subnet_prefixes         = var.subnet_prefixes
  subnet_names            = var.subnet_names

  # TODO: update to make dynamic
  subnet_enforce_private_link_endpoint_network_policies = {
    "snet-azure-ai-demo-private-endpoint" : true
  }
  # subnet_delegation = {
  #   subnet1 = [
  #     {
  #       name = "delegation"
  #       service_delegation = {
  #         name = "Microsoft.ContainerInstance/containerGroups"
  #         actions = [
  #           "Microsoft.Network/virtualNetworks/subnets/action",
  #         ]
  #       }
  #     }
  #   ]
  # }

  # TODO: update to make dynamic
  # subnet_service_endpoints = {
  #   "subnet1" : ["Microsoft.Sql"]
  # }

  tags         = var.tags
  use_for_each = true
}
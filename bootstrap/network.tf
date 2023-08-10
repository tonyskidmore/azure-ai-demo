module "network" {
  source                  = "Azure/network/azurerm"
  version                 = "5.2.0"
  vnet_name               = var.vmss_vnet_name
  resource_group_name     = azurerm_resource_group.azure-ai-demo.name
  resource_group_location = azurerm_resource_group.azure-ai-demo.location
  address_spaces          = var.vnet_address_space
  subnet_prefixes         = var.subnet_prefixes
  subnet_names            = var.subnet_names

  subnet_enforce_private_link_endpoint_network_policies = {
    "snet-azure-ai-demo-private-endpoint" : true
  }
  subnet_delegation = {
    snet-azure-ai-demo-vnet-int = [
      {
        name = "delegation"
        service_delegation = {
          name = "Microsoft.Web/serverFarms"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/action",
          ]
        }
      }
    ]
  }

  # required?
  subnet_service_endpoints = {
    "snet-azure-ai-demo-private-endpoint"         = [ "Microsoft.CognitiveServices" ]
  }

  tags         = var.tags
  use_for_each = true
}

# TODO: add NSGs and associations

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

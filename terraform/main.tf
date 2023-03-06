data "azurerm_client_config" "current" {}

resource "random_string" "build_index" {
  length      = 6
  min_numeric = 6
}

data "azurerm_resource_group" "ai-demo" {
  name = var.resource_group_name
}

data "azurerm_virtual_machine_scale_set" "bootstrap" {
  name                = var.vmss_name
  resource_group_name = var.bootstrap_resource_group_name
}

data "azurerm_virtual_network" "bootstrap" {
  name                = var.vmss_vnet_name
  resource_group_name = var.bootstrap_resource_group_name
}

data "azurerm_subnet" "private_endpoints" {
  name                 = var.subnet_name_private_endpoint
  virtual_network_name = data.azurerm_virtual_network.bootstrap.name
  resource_group_name  = var.bootstrap_resource_group_name
}

data "azurerm_subnet" "vnet_integration" {
  name                 = var.subnet_name_vnet_integration
  virtual_network_name = data.azurerm_virtual_network.bootstrap.name
  resource_group_name  = var.bootstrap_resource_group_name
}

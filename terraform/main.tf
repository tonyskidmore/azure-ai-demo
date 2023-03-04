provider "azurerm" {
  features {}
}

resource "random_string" "build_index" {
  length      = 6
  min_numeric = 6
}

resource "azurerm_resource_group" "ai-demo" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

data "azurerm_virtual_machine_scale_set" "bootstrap" {
  name                = "rg-azure-ai-demo-bootstrap"
  resource_group_name = "vmss-azure-ai-demo-bootstrap"
}

output "vmss" {
  value = data.azurerm_virtual_machine_scale_set.bootstrap
}

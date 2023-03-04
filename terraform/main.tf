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

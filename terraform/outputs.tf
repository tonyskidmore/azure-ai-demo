output "vmss" {
  value = data.azurerm_virtual_machine_scale_set.bootstrap
}

output "virtual_network" {
  value = data.azurerm_virtual_network.bootstrap
}

output "vnet_integration_subnet_id" {
  value = data.azurerm_subnet.vnet_integration.id
}

output "translator" {
  value     = azurerm_cognitive_account.translate
  sensitive = true
}

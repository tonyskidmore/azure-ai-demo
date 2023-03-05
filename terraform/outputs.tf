output "vmss" {
  value = data.azurerm_virtual_machine_scale_set.bootstrap
}

output "virtual_network" {
  value = data.azurerm_virtual_network.bootstrap
}

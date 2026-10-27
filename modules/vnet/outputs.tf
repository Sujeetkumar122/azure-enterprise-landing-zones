output "vnet_ids" {
  description = "Map of VNet names to IDs"
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.id }
}

output "subnet_ids" {
  description = "Map of Subnet keys to IDs"
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
}

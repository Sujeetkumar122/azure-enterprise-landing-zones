output "resource_group_names" {
  description = "Created Resource Groups"
  value       = [for k, v in azurerm_resource_group.rg : v.name]
}

output "vnet_ids" {
  description = "Virtual Network IDs"
  value       = module.vnet.vnet_ids
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = module.vnet.subnet_ids
}

output "nsg_ids" {
  description = "Network Security Group IDs"
  value       = module.nsg.nsg_ids
}

output "route_table_ids" {
  description = "Route Table IDs"
  value       = module.route_table.route_table_ids
}

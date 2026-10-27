# Route Table module using for_each + map and dynamic route blocks

resource "azurerm_route_table" "rt" {
  for_each                      = var.route_tables
  name                          = each.key
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  disable_bgp_route_propagation = lookup(each.value, "disable_bgp_route_propagation", false)

  dynamic "route" {
    for_each = each.value.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = merge(var.common_tags, lookup(each.value, "tags", {}))
}

variable "route_tables" {
  description = "Map of Route Tables with routes"
  type = map(object({
    location                      = string
    resource_group_name           = string
    disable_bgp_route_propagation = optional(bool)
    tags                          = optional(map(string))
    routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    }))
  }))
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

output "route_table_ids" {
  description = "Map of Route Table names to IDs"
  value       = { for k, v in azurerm_route_table.rt : k => v.id }
}

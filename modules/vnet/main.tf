# Virtual Network and Subnet Module using for_each + map

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnets
  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  dns_servers         = lookup(each.value, "dns_servers", null)

  tags = merge(var.common_tags, lookup(each.value, "tags", {}))
}

resource "azurerm_subnet" "subnet" {
  for_each = {
    for subnet in local.subnets_flat : "${subnet.vnet_key}.${subnet.name}" => subnet
  }

  name                                          = each.value.name
  resource_group_name                           = each.value.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnet[each.value.vnet_key].name
  address_prefixes                              = each.value.address_prefixes
  private_endpoint_network_policies_enabled     = lookup(each.value, "private_endpoint_network_policies_enabled", false)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", true)
  service_endpoints                             = lookup(each.value, "service_endpoints", [])

  dynamic "delegation" {
    for_each = lookup(each.value, "delegations", [])
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = lookup(delegation.value, "actions", [])
      }
    }
  }
}

locals {
  subnets_flat = flatten([
    for vnet_key, vnet in var.vnets : [
      for subnet in vnet.subnets : merge(subnet, {
        vnet_key            = vnet_key
        location            = vnet.location
        resource_group_name = vnet.resource_group_name
      })
    ]
  ])
}

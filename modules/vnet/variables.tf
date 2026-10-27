variable "vnets" {
  description = "Map of Virtual Networks with subnets"
  type = map(object({
    location            = string
    resource_group_name = string
    address_space       = list(string)
    dns_servers         = optional(list(string))
    tags                = optional(map(string))
    subnets = list(object({
      name                                          = string
      address_prefixes                              = list(string)
      service_endpoints                             = optional(list(string))
      private_endpoint_network_policies_enabled     = optional(bool)
      private_link_service_network_policies_enabled = optional(bool)
      delegations = optional(list(object({
        name         = string
        service_name = string
        actions      = optional(list(string))
      })))
    }))
  }))
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "private_dns_zones" {
  default = {
    "ampls"        = "privatelink.monitor.azure.com"
    "oms"          = "privatelink.oms.opinsights.azure.com"
    "ods"          = "privatelink.ods.opinsights.azure.com"
    "aks"          = "privatelink.azmk8s.io"
  }
}

resource "azurerm_private_dns_zone" "zones" {
  for_each            = var.private_dns_zones
  name                = each.value
  resource_group_name = azurerm_resource_group.container_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each                = var.private_dns_zones
  name                    = "${each.key}-dns-link"
  resource_group_name     = azurerm_resource_group.container_rg.name
  private_dns_zone_name   = azurerm_private_dns_zone.zones[each.key].name
  virtual_network_id      = azurerm_virtual_network.aks_vnet.id
}


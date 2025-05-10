resource "azurerm_private_dns_zone" "ampls_dns" {
  name                = "privatelink.monitor.azure.com"
  resource_group_name = azurerm_resource_group.container_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "ampls-dns-link"
  resource_group_name   = azurerm_resource_group.container_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.ampls_dns.name
  virtual_network_id    = azurerm_virtual_network.aks_vnet.id
}

resource "azurerm_private_dns_zone" "oms_opinsights" {
  name                = "oms.opinsights.azure.com"
  resource_group_name = "grownpossum-rg"
}

resource "azurerm_private_dns_zone_virtual_network_link" "oms_opinsights_dns_link" {
  name                  = "oms-opinsights-dns-link"  # Unique name
  resource_group_name   = "grownpossum-rg"
  private_dns_zone_name = azurerm_private_dns_zone.oms_opinsights.name  # Correct reference
  virtual_network_id    = azurerm_virtual_network.aks_vnet.id
}

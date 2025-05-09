resource "azurerm_monitor_private_link_scope" "ampls" {
  name                = "${var.project_name}-ampls"
  resource_group_name = azurerm_resource_group.container_rg.name
}

resource "azurerm_monitor_private_link_scoped_service" "ampls_law" {
  name                 = "ampls-law"
  resource_group_name  = azurerm_monitor_private_link_scope.ampls.resource_group_name
  scope_name           = azurerm_monitor_private_link_scope.ampls.name
  linked_resource_id   = azurerm_log_analytics_workspace.monitoring_law.id 
}

resource "azurerm_private_endpoint" "ampls_pe" {
  name                = "${var.project_name}-ampls-pe"
  location            = azurerm_resource_group.container_rg.location
  resource_group_name = azurerm_resource_group.container_rg.name
  subnet_id           = azurerm_subnet.private_link_subnet.id

  private_service_connection {
    name                           = "${var.project_name}-ampls-psc"
    private_connection_resource_id = azurerm_monitor_private_link_scope.ampls.id
    is_manual_connection           = false
    subresource_names              = ["azuremonitor"]
  }
}


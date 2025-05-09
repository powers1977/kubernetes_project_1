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


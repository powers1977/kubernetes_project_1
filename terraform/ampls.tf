resource "azurerm_monitor_private_link_scope" "ampls" {
  name                = "${var.project_name}-ampls"
  resource_group_name = azurerm_resource_group.container_rg.name
}

#resource "azurerm_monitor_private_link_scope_log_analytics_workspace_association" "ampls_law" {
#  scope_name          = azurerm_monitor_private_link_scope.ampls.name
#  resource_group_name = azurerm_resource_group.container_rg.name
#  workspace_id        = azurerm_log_analytics_workspace.monitoring_law.id
#}
#
#resource "azurerm_monitor_private_link_scope_data_collection_endpoint_association" "ampls_dce" {
#  scope_name              = azurerm_monitor_private_link_scope.ampls.name
#  resource_group_name     = azurerm_resource_group.container_rg.name
#  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.aks_dce.id
#}


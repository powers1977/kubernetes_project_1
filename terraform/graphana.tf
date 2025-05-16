resource "azurerm_dashboard_grafana" "main" {
  name                = "${var.project_name}-grafana"
  location            = var.location
  resource_group_name = azurerm_resource_group.container_rg.name
  grafana_major_version  = 9

  identity {
    type = "SystemAssigned"
  }

  #sku = "Standard" # You can also try "Basic" if cost is a concern
  sku = "Basic" # You can also try "Basic" if cost is a concern
}

# Required for role assignment below
data "azurerm_subscription" "current" {}

# Grant Grafana permission to read monitoring data (Log Analytics, metrics)
resource "azurerm_role_assignment" "grafana_monitoring_reader" {
  #scope                = data.azurerm_subscription.current.id
  scope                = azurerm_resource_group.container_rg.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.main.identity[0].principal_id
}

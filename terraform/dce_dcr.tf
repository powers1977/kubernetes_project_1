resource "azurerm_monitor_data_collection_endpoint" "aks_dce" {
  name                = "${var.project_name}-dce"
  location            = azurerm_resource_group.container_rg.location
  resource_group_name = azurerm_resource_group.container_rg.name
  kind                = "Linux"
  #tags                = var.tags
}

resource "azurerm_monitor_data_collection_endpoint_association" "aks_dce_association" {
  name                         = "${var.project_name}-dce-association"
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.aks_dce.id
  target_resource_id          = azurerm_kubernetes_cluster.aks.id

  depends_on = [
    azurerm_monitor_data_collection_endpoint.aks_dce,
    azurerm_kubernetes_cluster.aks
  ]
}

resource "azurerm_monitor_data_collection_rule" "aks_dcr" {
  name                          = "${var.project_name}-aks-dcr"
  location                      = azurerm_resource_group.container_rg.location
  resource_group_name           = azurerm_resource_group.container_rg.name
  data_collection_endpoint_id   = azurerm_monitor_data_collection_endpoint.aks_dce.id

  destinations {
    log_analytics {
      name          = "logAnalyticsDest"
      workspace_resource_id  = azurerm_log_analytics_workspace.monitoring_law.id
    }
  }

  data_sources {
    performance_counter {
      name                          = "perfCounterDataSource"
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\Available MBytes"
      ]
    }
  }
    data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["logAnalyticsDest"]
  }
}

resource "azurerm_monitor_data_collection_rule_association" "aks_dcr_association" {
  name                    = "${var.project_name}-dcr-association"
  data_collection_rule_id = azurerm_monitor_data_collection_rule.aks_dcr.id
  target_resource_id      = azurerm_kubernetes_cluster.aks.id

  depends_on = [
    azurerm_monitor_data_collection_rule.aks_dcr,
    azurerm_monitor_data_collection_endpoint.aks_dce,
    azurerm_kubernetes_cluster.aks
  ]
}


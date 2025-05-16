resource "azurerm_container_registry" "acr" {
  #name                = "acr-${random_pet.acr_name.id}"
  #name                = "acr${local.pet_clean_name}"
  name                = "acr${var.project_name}"
  resource_group_name = azurerm_resource_group.container_rg.name
  location            = azurerm_resource_group.container_rg.location
  sku                  = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  #name                = "aks${local.pet_clean_name}"
  name                = "aks${var.project_name}"
  location            = azurerm_resource_group.container_rg.location
  resource_group_name = azurerm_resource_group.container_rg.name
  #dns_prefix          = "aks${local.pet_clean_name}"
  dns_prefix          = "aks${var.project_name}"

  default_node_pool {
    name       = "default"
    node_count = 1
    #vm_size    = "Standard_DS2_v2"
    vm_size    = "Standard_B2s"
        #__add line below if you have a VNET. Leave out to use default AKS VNET
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr      = "10.2.0.0/16"
    dns_service_ip    = "10.2.0.10"
  }
  #addon_profile {
  #oms_agent {
  #  enabled                    = true
  #  log_analytics_workspace_id = azurerm_log_analytics_workspace.monitoring_law.id
  #}
  #}
}

#resource "azurerm_kubernetes_cluster_extension" "ingress_nginx" {
#  name                 = "ingress-nginx"
#  cluster_id           = azurerm_kubernetes_cluster.aks.id
#  extension_type       = "microsoft.ingress.nginx"
#  release_train        = "Stable"
#
#  #might be needed in future version
#  #auto_upgrade_minor_version = true
#
#  configuration_settings = {
#    "controller.enableCertManager" = "false"
#  }
#}

# Give AKS permission to pull from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  #principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# Output ACR Login Server URL
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

# Output AKS name
output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name

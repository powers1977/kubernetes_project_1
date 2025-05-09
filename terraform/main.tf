terraform {
  required_version = ">= 1.5.0"
  backend "azurerm" {
    resource_group_name  = "devops-rg"
    storage_account_name = "devopsryanstorage01"
    container_name       = "kubernetes-project-1-tfstate"
    key                  = "resources.tfstate"
    lineage              = "ryan-lineage"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = ">= 2.4.1"
      #version = ">= 2.91.0" # newer version supports extensions
      version = ">= 3.80.0"
    }
  }
}

# Provider Configuration
provider "azurerm" {
  features {}
}

# Static project name
variable "project_name" {
  type    = string
  default = "grownpossum"
}

variable "location" {
  type    = string
  default = "eastus"
}


# Random provider for generating the unique, memorable name
#resource "random_pet" "acr_name" {
#  length = 2  # Two words: an adjective and an animal
#}

# Define a local variable to remove hyphens
#locals {
#  pet_clean_name = replace(random_pet.acr_name.id, "-", "")
#}

# Resource Group for ACR
resource "azurerm_resource_group" "container_rg" {
  #name     = "containers-rg"
  name     = "${var.project_name}-rg"
  #location = "East US"
  location = var.location 
}

resource "azurerm_log_analytics_workspace" "monitoring_law" {
  name                = "${var.project_name}-law"
  location            = azurerm_resource_group.container_rg.location
  resource_group_name = azurerm_resource_group.container_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.container_rg.name 
  #tags                = var.tags
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.project_name}-subnet"
  resource_group_name  = azurerm_resource_group.container_rg.name 
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private_link_subnet" {
  name                                          = "${var.project_name}-private-endpoint-subnet"
  resource_group_name                           = azurerm_resource_group.container_rg.name
  virtual_network_name                          = azurerm_virtual_network.aks_vnet.name
  address_prefixes                              = ["10.0.2.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

# Azure Container Registry with a more readable, unique name
resource "azurerm_container_registry" "acr" {
  #name                = "acr-${random_pet.acr_name.id}"
  #name                = "acr${local.pet_clean_name}"
  name                = "acr${var.project_name}"
  resource_group_name = azurerm_resource_group.container_rg.name
  location            = azurerm_resource_group.container_rg.location
  sku                  = "Basic"
  admin_enabled       = true
}
# Azure Kubernetes Service (AKS) Cluster (future-proof version)
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
    vm_size    = "Standard_DS2_v2"
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
#  addon_profile {
#  oms_agent {
#    enabled                    = true
#    log_analytics_workspace_id = azurerm_log_analytics_workspace.monitoring_law.id
#  }
#  }
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
}

output "law_workspace_id" {
  value = azurerm_log_analytics_workspace.monitoring_law.id
}



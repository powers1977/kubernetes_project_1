terraform {
  backend "azurerm" {
    resource_group_name  = "devops-rg"
    storage_account_name = "devopsryanstorage01"
    container_name       = "container-project-1-tfstate"
    key                  = "resources.tfstate"
    lineage              = "ryan-lineage"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.4.1"
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
  location = "East US"
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
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

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


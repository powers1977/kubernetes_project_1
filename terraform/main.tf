terraform {
  required_version = ">= 1.5.0"
  backend "azurerm" {
    resource_group_name  = "devops-rg"
    storage_account_name = "devopsryanstorage01"
    container_name       = "kubernetes-project-1-tfstate"
    key                  = "resources.tfstate"
    #lineage              = "ryan-lineage"
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
  use_cli  = true
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
}

output "law_workspace_id" {
  value = azurerm_log_analytics_workspace.monitoring_law.id
}



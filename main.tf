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

# Random provider for generating the unique, memorable name
resource "random_pet" "acr_name" {
  length = 2  # Two words: an adjective and an animal
}

# Resource Group for ACR
resource "azurerm_resource_group" "container_rg" {
  name     = "containers-rg"
  location = "East US"
}

# Azure Container Registry with a more readable, unique name
resource "azurerm_container_registry" "acr" {
  #name                = "acr-${random_pet.acr_name.id}"
  name                = "acr-${replace(random_pet.acr_name.id, "-", "")}"
  resource_group_name = azurerm_resource_group.container_rg.name
  location            = azurerm_resource_group.container_rg.location
  sku                  = "Basic"
  admin_enabled       = true
}

# Output ACR Login Server URL
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}


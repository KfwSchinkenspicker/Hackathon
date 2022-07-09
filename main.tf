# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  tenant_id = "bfe3e775-4326-4a0a-92dc-b73064a9ce24"
  subscription_id = "c7eecf81-6171-4cc0-96c3-4bd3382787af"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "schinkenspicker" {
  name     = "schinkenspicker"
  location = "East US"
}

# Create Registry
resource "azurerm_container_registry" "schinkenspicker_registry" {
  name                = "schinkenspicker"
  resource_group_name = azurerm_resource_group.schinkenspicker.name
  location            = azurerm_resource_group.schinkenspicker.location
  sku                 = "Standard"
}

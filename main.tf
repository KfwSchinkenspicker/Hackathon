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
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "schinkenspicker" {
  name     = "schinkenspicker"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "schinkenspicker" {
  name                = "schinkenspicker"
  resource_group_name = azurerm_resource_group.schinkenspicker.name
  location            = azurerm_resource_group.schinkenspicker.location
  address_space       = ["10.0.0.0/16"]
}
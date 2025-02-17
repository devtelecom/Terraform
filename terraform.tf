# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  client_id       =  "1a35546f-e935-4e8d-89c1-88cfac524cea"
  client_secret   =  "xAO8Q~D~OlNx3aq-gJhrKlRe54LWiQ~NULjjDbro"
  tenant_id       =  "2f269271-b492-4913-81b0-97e1e85cb153"
  subscription_id =  "b5db29b7-191b-4e43-a679-680d700aa98b"
}
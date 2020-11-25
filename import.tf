provider "azurerm" {
    version="2.37.0"
}

# create resource group
resource "azurerm_resource_group" "MC_ml_cloud_k8s_az-k8s-entercloud_westus" {
    name = "MC_ml_cloud_k8s_az-k8s-entercloud_westus"
    location = "westus"
      tags = {
    ml = "cloud"
  }
  }

  resource "azurerm_resource_group" "aks-agentpool-31317223-routetable" {
    name = "aks-agentpool-31317223-routetable"
    location = "westus"
      tags = {
    ml = "cloud"
  }
  }

  resource "azurerm_resource_group" "cloud-shell-storage-eastus"{
    name = "cloud-shell-storage-eastus"
    location = "eastus"
  }
  
provider "azurerm" {
    version="2.37.0"
}

# create resource group
resource "azurerm_resource_group" "rg"{
    name = "MC_ml_cloud_k8s_az-k8s-entercloud_westus"
    location = "westus"
}

resource "azurerm_resource_group" "cloud-shell-storage-eastus"{
    name = "cloud-shell-storage-eastus"
    location = "eastus"
}


resource "azurerm_resource_group" "ml_cloud_k8s"{
    name = "ml_cloud_k8s"
    location = "westus"
    tag = {
        ml: "cloud_k8s"
    }
}
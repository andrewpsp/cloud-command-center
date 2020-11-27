provider "azurerm" {
  version = "2.37.0"
}

# create resource group
resource "azurerm_resource_group" "MC_ml_cloud_k8s_az-k8s-entercloud_westus" {
  name     = "MC_ml_cloud_k8s_az-k8s-entercloud_westus"
  location = "westus"
  tags = {
    ml = "cloud"
  }
}

resource "azurerm_resource_group" "aks-agentpool-31317223-routetable" {
  name     = "aks-agentpool-31317223-routetable"
  location = "westus"
  tags = {
    ml = "cloud"
  }
}

resource "azurerm_resource_group" "cloud-shell-storage-eastus" {
  name     = "cloud-shell-storage-eastus"
  location = "eastus"
}

resource "azurerm_resource_group" "ml_cloud_k8s" {
  name     = "ml_cloud_k8s"
  location = "westus"
  tag = {
    ml = "cloud_k8s"
  }
}

resource "azurerm_resource_group" "NetworkWatcherRG" {
  name     = "NetworkWatcherRG"
  location = "westus"
  tag = {
    ml = "NetworkWatcherRG"
  }
}


terraform {
  backend "remote" {
    organization = 
  }
}



# ------------------
#  -----------------

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    load_balancer_sku = "standard"
  }

  service_principal {
    client_id     = azuread_service_principal.example.application_id
    client_secret = var.password
  }

  addon_profile {
    aci_connector_linux {
      enabled = true
      subnet_name = azurerm_subnet.example-aci.name
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = true
    }

    oms_agent {
      enabled = false
    }
  }
}
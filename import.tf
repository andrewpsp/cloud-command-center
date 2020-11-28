provider "azurerm" {
  features {}
}

#add remote backend 
terraform {
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "Entercloud"

    workspaces {
      name = "dev-entercloud-app01"
    }
  }
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
}

resource "azurerm_resource_group" "NetworkWatcherRG" {
  name     = "NetworkWatcherRG"
  location = "westus"

}


#azurerm_kubernetes_cluster

resource "azurerm_kubernetes_cluster" "az-k8s-entercloud" {
  name                = "az-k8s-entercloud"
  resource_group_name = "ml_cloud_k8s"
  location            = "westus"
  dns_prefix          = "az-k8s-ent-mlcloudk8s-a1364e"


  default_node_pool {
    name       = "nodepool1"
    node_count = 1
    vm_size    = "Standard_A2_v2"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

  service_principal {
    client_id     = azuread_service_principal.srv_principal.application_id
    client_secret = "password"
  }

  addon_profile {
    aci_connector_linux {
      enabled     = true
      subnet_name = azurerm_subnet.aks-aci.name
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = true
    }

    kube_dashboard {
      enabled = true
    }

    oms_agent {
      enabled = false
    }
  }
}

# import network 

resource "azurerm_virtual_network" "aks-vnet-31317223" {
  name                = "aks-vnet-31317223"
  location            = "westus"
  resource_group_name = "MC_ml_cloud_k8s_az-k8s-entercloud_westus"
  address_space       = ["10.0.0.0/8"]
}


resource "azurerm_subnet" "aks-subnet" {
  name                 = "aks-subnet"
  virtual_network_name = azurerm_virtual_network.aks-vnet-31317223.name
  resource_group_name  = "MC_ml_cloud_k8s_az-k8s-entercloud_westus"
  address_prefixes     = ["10.240.0.0/16"]
}


resource "azurerm_subnet" "aks-aci" {
  name                 = "aks-aci"
  virtual_network_name = azurerm_virtual_network.aks-vnet-31317223.name
  resource_group_name  = "MC_ml_cloud_k8s_az-k8s-entercloud_westus"
  address_prefixes     = ["10.240.3.0/16"]

  delegation {
    name = "aciDelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


resource "azurerm_role_assignment" "aks_role" {
  scope                = azurerm_subnet.aks-aci.id
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.srv_principal.object_id
}

resource "azuread_application" "app_read" {
  name                       = "app_read"
  homepage                   = "http://homepage"
  identifier_uris            = ["http://uri"]
  reply_urls                 = ["http://replyurl"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "srv_principal" {
  application_id               = azuread_application.app_read.application_id
  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "password" {
  service_principal_id = azuread_service_principal.srv_principal.id
  description          = "My raw password"
  value                = "password"
  end_date             = "2099-01-01T01:02:03Z"
}
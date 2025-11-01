resource "azurerm_resource_group" "az-k8s-rg" {
  name     = "az-k8s-rg"
  location = "East US 2"
}

resource "azurerm_kubernetes_cluster" "az-k8s-cluster" {
  name                = "az-k8s-cluster"
  location            = azurerm_resource_group.az-k8s-rg.location
  resource_group_name = azurerm_resource_group.az-k8s-rg.name
  dns_prefix          = "aksmultienv"

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "multi"
    Purpose     = "dev-stage-prod"
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "prod" {
  name                  = "prod"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.az-k8s-cluster.id
  vm_size               = "Standard_DS3_v2"
  node_count            = 1

  tags = {
    Environment = "production"
  }

  node_taints = [
    "environment=production:NoSchedule"
  ]
}


resource "azurerm_kubernetes_cluster_node_pool" "devstage" {
  name                  = "devstage"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.az-k8s-cluster.id
  vm_size               = "Standard_DS3_v2"
  node_count            = 1

  tags = {
    Environment = "non-production"
  }

  node_taints = [
    "environment=non-production:NoSchedule"
  ]
}

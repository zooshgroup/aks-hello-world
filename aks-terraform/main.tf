resource "random_pet" "random_name" {
}

resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = "aks-hello-world"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = "aks-hello-world"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = random_pet.random_name.id

  default_node_pool {
    name                = "agentpool"
    vm_size             = "Standard_B2s"
    enable_auto_scaling = false
    os_disk_size_gb     = 30
    node_count          = 1
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "basic"
  }

}

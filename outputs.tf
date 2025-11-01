output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks_cluster.name
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks_cluster.id
}

output "kube_config" {
  description = "Raw kubeconfig for the AKS cluster"
  value       = module.aks_cluster.kube_config_raw
  sensitive   = true
}

output "client_certificate" {
  description = "Client certificate for the AKS cluster"
  value       = module.aks_cluster.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Client key for the AKS cluster"
  value       = module.aks_cluster.client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate for the AKS cluster"
  value       = module.aks_cluster.cluster_ca_certificate
  sensitive   = true
}

output "cluster_endpoint" {
  description = "Endpoint for the AKS cluster"
  value       = module.aks_cluster.cluster_endpoint
  sensitive   = true
}

output "prod_node_pool_id" {
  description = "ID of the production node pool"
  value       = module.prod_node_pool.id
}

output "devstage_node_pool_id" {
  description = "ID of the dev/stage node pool"
  value       = module.devstage_node_pool.id
}

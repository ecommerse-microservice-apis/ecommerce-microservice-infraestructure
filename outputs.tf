################################################################################
# AZURE OUTPUTS
# Outputs for Azure AKS infrastructure
################################################################################

# Azure Resource Group Outputs
output "azure_resource_group_name" {
  description = "Name of the Azure resource group"
  value       = module.resource_group.name
}

# Azure AKS Cluster Outputs
output "azure_aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks_cluster.name
}

output "azure_aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks_cluster.id
}

output "azure_kube_config" {
  description = "Raw kubeconfig for the AKS cluster"
  value       = module.aks_cluster.kube_config_raw
  sensitive   = true
}

output "azure_client_certificate" {
  description = "Client certificate for the AKS cluster"
  value       = module.aks_cluster.client_certificate
  sensitive   = true
}

output "azure_client_key" {
  description = "Client key for the AKS cluster"
  value       = module.aks_cluster.client_key
  sensitive   = true
}

output "azure_cluster_ca_certificate" {
  description = "Cluster CA certificate for the AKS cluster"
  value       = module.aks_cluster.cluster_ca_certificate
  sensitive   = true
}

output "azure_cluster_endpoint" {
  description = "Endpoint for the AKS cluster"
  value       = module.aks_cluster.cluster_endpoint
  sensitive   = true
}

# Azure AKS Node Pool Outputs
output "azure_prod_node_pool_id" {
  description = "ID of the Azure production node pool"
  value       = module.azure_prod_node_pool.id
}

output "azure_devstage_node_pool_id" {
  description = "ID of the Azure dev/stage node pool"
  value       = module.azure_devstage_node_pool.id
}

################################################################################
# AWS OUTPUTS
# Outputs for AWS EKS infrastructure
################################################################################

# AWS VPC Outputs
output "aws_vpc_id" {
  description = "ID of the AWS VPC"
  value       = module.aws_vpc.vpc_id
}

output "aws_subnet_ids" {
  description = "IDs of the AWS public subnets"
  value       = module.aws_vpc.public_subnet_ids
}

# AWS EKS Cluster Outputs
output "aws_eks_cluster_id" {
  description = "ID of the EKS cluster"
  value       = module.aws_eks_cluster.cluster_id
}

output "aws_eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.aws_eks_cluster.cluster_name
}

output "aws_eks_cluster_endpoint" {
  description = "Endpoint for the EKS cluster API server"
  value       = module.aws_eks_cluster.cluster_endpoint
  sensitive   = true
}

output "aws_eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for EKS cluster authentication"
  value       = module.aws_eks_cluster.cluster_certificate_authority_data
  sensitive   = true
}

output "aws_eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = module.aws_eks_cluster.cluster_version
}

# AWS EKS Node Group Outputs
output "aws_eks_prod_node_group_id" {
  description = "ID of the EKS production node group"
  value       = module.aws_eks_prod_node_group.node_group_id
}

output "aws_eks_devstage_node_group_id" {
  description = "ID of the EKS dev/stage node group"
  value       = module.aws_eks_devstage_node_group.node_group_id
}

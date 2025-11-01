# AWS EKS Cluster Module
# This module creates an EKS (Elastic Kubernetes Service) cluster
# The cluster is the control plane that manages Kubernetes workloads

# EKS Cluster - Managed Kubernetes control plane
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  # VPC Configuration - Defines where cluster endpoints are accessible
  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  # Enable control plane logging for monitoring and troubleshooting
  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = var.tags

  # Ensure IAM role is created before cluster
  depends_on = [var.cluster_iam_role_policy_attachment]
}

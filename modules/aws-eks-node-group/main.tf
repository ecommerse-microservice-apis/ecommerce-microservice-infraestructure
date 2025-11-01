# AWS EKS Node Group Module
# This module creates a managed node group for an EKS cluster
# Node groups are EC2 instances that run your Kubernetes workloads

# EKS Node Group - Managed worker nodes for the cluster
resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  # Scaling configuration for the node group
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  # EC2 instance configuration
  instance_types = var.instance_types
  disk_size      = var.disk_size
  capacity_type  = var.capacity_type

  # Kubernetes labels for pod scheduling
  labels = var.labels

  # Taints to control pod placement on nodes
  dynamic "taint" {
    for_each = var.taints
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  # Update configuration for node group updates
  update_config {
    max_unavailable_percentage = var.max_unavailable_percentage
  }

  tags = var.tags

  # Ensure IAM role policies are attached before creating node group
  depends_on = [var.node_group_dependencies]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config[0].desired_size]
  }
}

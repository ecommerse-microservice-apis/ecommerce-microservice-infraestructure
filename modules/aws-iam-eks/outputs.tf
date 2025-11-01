output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_iam_role.cluster.arn
}

output "cluster_role_name" {
  description = "Name of the EKS cluster IAM role"
  value       = aws_iam_role.cluster.name
}

output "node_group_role_arn" {
  description = "ARN of the EKS node group IAM role"
  value       = aws_iam_role.node_group.arn
}

output "node_group_role_name" {
  description = "Name of the EKS node group IAM role"
  value       = aws_iam_role.node_group.name
}

output "node_group_policy_attachments" {
  description = "List of policy attachment IDs for node group dependencies"
  value = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy.id,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy.id,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly.id,
  ]
}

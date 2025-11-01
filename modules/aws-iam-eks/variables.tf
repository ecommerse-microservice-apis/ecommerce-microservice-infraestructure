variable "cluster_role_name" {
  description = "Name of the IAM role for EKS cluster"
  type        = string
}

variable "node_group_role_name" {
  description = "Name of the IAM role for EKS node groups"
  type        = string
}

variable "tags" {
  description = "Tags to apply to IAM roles"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "az-k8s-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US 2"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "az-k8s-cluster"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "aksmultienv"
}

variable "default_node_pool" {
  description = "Configuration for the default node pool"
  type = object({
    name       = string
    node_count = number
    vm_size    = string
  })
  default = {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
}

variable "prod_node_pool" {
  description = "Configuration for the production node pool"
  type = object({
    vm_size    = string
    node_count = number
  })
  default = {
    vm_size    = "Standard_DS3_v2"
    node_count = 1
  }
}

variable "devstage_node_pool" {
  description = "Configuration for the dev/stage node pool"
  type = object({
    vm_size    = string
    node_count = number
  })
  default = {
    vm_size    = "Standard_DS3_v2"
    node_count = 1
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "Multi-Cloud-K8s"
  }
}

################################################################################
# AWS VARIABLES
# Variables for AWS EKS infrastructure
################################################################################

# AWS VPC Configuration
variable "aws_vpc_name" {
  description = "Name of the AWS VPC"
  type        = string
  default     = "eks-vpc"
}

variable "aws_vpc_cidr" {
  description = "CIDR block for the AWS VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_availability_zones" {
  description = "List of availability zones for AWS subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "aws_public_subnet_cidrs" {
  description = "CIDR blocks for AWS public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# AWS IAM Configuration
variable "aws_eks_cluster_role_name" {
  description = "Name of the IAM role for EKS cluster"
  type        = string
  default     = "eks-cluster-role"
}

variable "aws_eks_node_group_role_name" {
  description = "Name of the IAM role for EKS node groups"
  type        = string
  default     = "eks-node-group-role"
}

# AWS EKS Cluster Configuration
variable "aws_eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "aws-k8s-cluster"
}

variable "aws_eks_kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.28"
}

variable "aws_eks_endpoint_private_access" {
  description = "Enable private API server endpoint for EKS"
  type        = bool
  default     = false
}

variable "aws_eks_endpoint_public_access" {
  description = "Enable public API server endpoint for EKS"
  type        = bool
  default     = true
}

variable "aws_eks_enabled_log_types" {
  description = "List of control plane logging types to enable for EKS"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# AWS EKS Node Groups Configuration
variable "aws_eks_prod_node_group" {
  description = "Configuration for the EKS production node group"
  type = object({
    desired_size   = number
    max_size       = number
    min_size       = number
    instance_types = list(string)
  })
  default = {
    desired_size   = 2
    max_size       = 3
    min_size       = 1
    instance_types = ["t3.medium"]
  }
}

variable "aws_eks_devstage_node_group" {
  description = "Configuration for the EKS dev/stage node group"
  type = object({
    desired_size   = number
    max_size       = number
    min_size       = number
    instance_types = list(string)
  })
  default = {
    desired_size   = 2
    max_size       = 3
    min_size       = 1
    instance_types = ["t3.medium"]
  }
}

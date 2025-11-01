################################################################################
# AZURE INFRASTRUCTURE
# This section creates AKS (Azure Kubernetes Service) resources
################################################################################

# Azure Resource Group - Logical container for Azure resources
module "resource_group" {
  source = "./modules/resource-group"

  name     = var.resource_group_name
  location = var.location
  tags     = var.common_tags
}

# Azure AKS Cluster - Managed Kubernetes service on Azure
module "aks_cluster" {
  source = "./modules/aks-cluster"

  cluster_name        = var.cluster_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  dns_prefix          = var.dns_prefix

  default_node_pool = var.default_node_pool

  tags = merge(
    var.common_tags,
    {
      Environment = "multi"
      Purpose     = "dev-stage-prod"
    }
  )
}

# Azure AKS Production Node Pool - Dedicated nodes for production workloads
module "azure_prod_node_pool" {
  source = "./modules/aks-node-pool"

  name                  = "prod"
  kubernetes_cluster_id = module.aks_cluster.id
  vm_size               = var.prod_node_pool.vm_size
  node_count            = var.prod_node_pool.node_count

  node_taints = [
    "environment=production:NoSchedule"
  ]

  tags = {
    Environment = "production"
  }
}

# Azure AKS Dev/Stage Node Pool - Dedicated nodes for development and staging
module "azure_devstage_node_pool" {
  source = "./modules/aks-node-pool"

  name                  = "devstage"
  kubernetes_cluster_id = module.aks_cluster.id
  vm_size               = var.devstage_node_pool.vm_size
  node_count            = var.devstage_node_pool.node_count

  node_taints = [
    "environment=non-production:NoSchedule"
  ]

  tags = {
    Environment = "non-production"
  }
}

################################################################################
# AWS INFRASTRUCTURE
# This section creates EKS (Elastic Kubernetes Service) resources
################################################################################

# AWS VPC - Virtual Private Cloud for EKS cluster networking
module "aws_vpc" {
  source = "./modules/aws-vpc"

  vpc_name            = var.aws_vpc_name
  vpc_cidr            = var.aws_vpc_cidr
  availability_zones  = var.aws_availability_zones
  public_subnet_cidrs = var.aws_public_subnet_cidrs

  tags = var.common_tags
}

# AWS IAM Roles - Identity and Access Management roles for EKS
module "aws_iam_eks" {
  source = "./modules/aws-iam-eks"

  cluster_role_name    = var.aws_eks_cluster_role_name
  node_group_role_name = var.aws_eks_node_group_role_name

  tags = var.common_tags
}

# AWS EKS Cluster - Managed Kubernetes service on AWS
module "aws_eks_cluster" {
  source = "./modules/aws-eks-cluster"

  cluster_name       = var.aws_eks_cluster_name
  cluster_role_arn   = module.aws_iam_eks.cluster_role_arn
  kubernetes_version = var.aws_eks_kubernetes_version
  subnet_ids         = module.aws_vpc.public_subnet_ids

  endpoint_private_access   = var.aws_eks_endpoint_private_access
  endpoint_public_access    = var.aws_eks_endpoint_public_access
  enabled_cluster_log_types = var.aws_eks_enabled_log_types

  tags = merge(
    var.common_tags,
    {
      Environment = "multi"
      Purpose     = "dev-stage-prod"
    }
  )
}

# AWS EKS Production Node Group - Dedicated nodes for production workloads
module "aws_eks_prod_node_group" {
  source = "./modules/aws-eks-node-group"

  cluster_name    = module.aws_eks_cluster.cluster_name
  node_group_name = "prod-node-group"
  node_role_arn   = module.aws_iam_eks.node_group_role_arn
  subnet_ids      = module.aws_vpc.public_subnet_ids

  desired_size   = var.aws_eks_prod_node_group.desired_size
  max_size       = var.aws_eks_prod_node_group.max_size
  min_size       = var.aws_eks_prod_node_group.min_size
  instance_types = var.aws_eks_prod_node_group.instance_types

  labels = {
    environment = "production"
  }

  taints = [
    {
      key    = "environment"
      value  = "production"
      effect = "NO_SCHEDULE"
    }
  ]

  node_group_dependencies = module.aws_iam_eks.node_group_policy_attachments

  tags = {
    Environment = "production"
  }
}

# AWS EKS Dev/Stage Node Group - Dedicated nodes for development and staging
module "aws_eks_devstage_node_group" {
  source = "./modules/aws-eks-node-group"

  cluster_name    = module.aws_eks_cluster.cluster_name
  node_group_name = "devstage-node-group"
  node_role_arn   = module.aws_iam_eks.node_group_role_arn
  subnet_ids      = module.aws_vpc.public_subnet_ids

  desired_size   = var.aws_eks_devstage_node_group.desired_size
  max_size       = var.aws_eks_devstage_node_group.max_size
  min_size       = var.aws_eks_devstage_node_group.min_size
  instance_types = var.aws_eks_devstage_node_group.instance_types

  labels = {
    environment = "non-production"
  }

  taints = [
    {
      key    = "environment"
      value  = "non-production"
      effect = "NO_SCHEDULE"
    }
  ]

  node_group_dependencies = module.aws_iam_eks.node_group_policy_attachments

  tags = {
    Environment = "non-production"
  }
}

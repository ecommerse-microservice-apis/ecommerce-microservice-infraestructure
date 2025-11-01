# ecommerce-microservice-infrastructure

Infrastructure as Code (IaC) for the e-commerce microservices project using Terraform with **multi-cloud modular architecture** supporting both **Azure AKS** and **AWS EKS**.

## Project Structure

```
infrastructure/
├── main.tf                    # Main orchestration file with Azure and AWS resources
├── variables.tf               # Variable definitions for both clouds
├── outputs.tf                 # Outputs for Azure and AWS resources
├── providers.tf               # Azure and AWS provider configuration
├── terraform.tfvars.example   # Example configuration file
└── modules/                   # Reusable cloud-agnostic modules
    ├── resource-group/        # Azure Resource Group module
    ├── aks-cluster/           # Azure AKS Cluster module
    ├── aks-node-pool/         # Azure AKS Node Pool module
    ├── aws-vpc/               # AWS VPC and networking module
    ├── aws-iam-eks/           # AWS IAM roles for EKS module
    ├── aws-eks-cluster/       # AWS EKS Cluster module
    └── aws-eks-node-group/    # AWS EKS Node Group module
```

## Multi-Cloud Architecture

This project creates parallel Kubernetes infrastructure across two cloud providers:

### Azure Infrastructure (AKS)

- **Resource Group**: Logical container for Azure resources
- **AKS Cluster**: Managed Kubernetes service with system node pool
- **Production Node Pool**: Dedicated nodes for production workloads (with taints)
- **Dev/Stage Node Pool**: Dedicated nodes for development and staging (with taints)

### AWS Infrastructure (EKS)

- **VPC**: Virtual Private Cloud with public subnets across 3 availability zones
- **IAM Roles**: Cluster and node group roles with required policies
- **EKS Cluster**: Managed Kubernetes service with logging enabled
- **Production Node Group**: Dedicated nodes for production workloads (with taints)
- **Dev/Stage Node Group**: Dedicated nodes for development and staging (with taints)

### Key Features

- **Multi-cloud deployment**: Deploy to Azure and AWS simultaneously
- **Modular architecture**: Reusable, testable, and maintainable modules
- **Environment separation**: Node pools/groups with taints for workload isolation
- **Parameterized configuration**: Customize deployments via variables
- **Comprehensive outputs**: Integration-ready outputs for CI/CD pipelines
- **Inline documentation**: Comments explain the purpose of each resource

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- Active Azure subscription
- Active AWS account with appropriate permissions

## Usage

### 1. Cloud Authentication

**Azure:**

```bash
az login
```

**AWS:**

```bash
aws configure
```

### 2. Configure Variables

Copy the example file and adjust values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your cloud-specific values.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Apply the Infrastructure

**Deploy both clouds:**

```bash
terraform apply
```

**Deploy only Azure:**

```bash
terraform apply -target=module.resource_group -target=module.aks_cluster \
  -target=module.azure_prod_node_pool -target=module.azure_devstage_node_pool
```

**Deploy only AWS:**

```bash
terraform apply -target=module.aws_vpc -target=module.aws_iam_eks \
  -target=module.aws_eks_cluster -target=module.aws_eks_prod_node_group \
  -target=module.aws_eks_devstage_node_group
```

### 6. Get Kubeconfig

**Azure AKS:**

```bash
az aks get-credentials --resource-group az-k8s-rg --name az-k8s-cluster
```

**AWS EKS:**

```bash
aws eks update-kubeconfig --region us-east-1 --name aws-k8s-cluster
```

## Main Variables

### Azure Variables

| Variable            | Description         | Default        |
| ------------------- | ------------------- | -------------- |
| resource_group_name | Resource group name | az-k8s-rg      |
| location            | Azure region        | East US 2      |
| cluster_name        | AKS cluster name    | az-k8s-cluster |
| dns_prefix          | DNS prefix          | aksmultienv    |

### AWS Variables

| Variable                   | Description        | Default         |
| -------------------------- | ------------------ | --------------- |
| aws_vpc_name               | VPC name           | eks-vpc         |
| aws_vpc_cidr               | VPC CIDR block     | 10.0.0.0/16     |
| aws_eks_cluster_name       | EKS cluster name   | aws-k8s-cluster |
| aws_eks_kubernetes_version | Kubernetes version | 1.28            |

See [variables.tf](variables.tf) for the complete list of variables.

## Outputs

After applying the configuration, retrieve outputs:

```bash
terraform output
```

Sensitive outputs (kubeconfig):

**Azure:**

```bash
terraform output -raw azure_kube_config > ~/.kube/azure-config
```

**AWS:**

```bash
# AWS kubeconfig is retrieved via aws eks update-kubeconfig
terraform output aws_eks_cluster_name
terraform output aws_eks_cluster_endpoint
```

## Modules

Each module is independent and reusable:

### Azure Modules

- **[resource-group](modules/resource-group/README.md)**: Creates Azure resource groups
- **[aks-cluster](modules/aks-cluster/README.md)**: Creates AKS clusters
- **[aks-node-pool](modules/aks-node-pool/README.md)**: Creates additional AKS node pools

### AWS Modules

- **aws-vpc**: Creates VPC with subnets, internet gateway, and routing
- **aws-iam-eks**: Creates IAM roles and policies for EKS
- **aws-eks-cluster**: Creates EKS cluster with logging
- **aws-eks-node-group**: Creates managed node groups with auto-scaling

## Modular Structure Benefits

- **Code reusability**: Use modules across different environments/projects
- **Easier maintenance**: Update modules independently
- **Independent testing**: Test each module in isolation
- **Version control**: Tag and version modules separately
- **Flexible composition**: Mix and match modules as needed
- **Cloud agnostic**: Easily extend to other cloud providers (GCP, etc.)

## Clean Up Resources

**Destroy all infrastructure:**

```bash
terraform destroy
```

**Destroy only Azure:**

```bash
terraform destroy -target=module.azure_devstage_node_pool \
  -target=module.azure_prod_node_pool -target=module.aks_cluster \
  -target=module.resource_group
```

**Destroy only AWS:**

```bash
terraform destroy -target=module.aws_eks_devstage_node_group \
  -target=module.aws_eks_prod_node_group -target=module.aws_eks_cluster \
  -target=module.aws_iam_eks -target=module.aws_vpc
```

## Best Practices

1. Never commit `terraform.tfvars` with sensitive values
2. Use remote backend for state (Azure Storage or S3)
3. Implement CI/CD for infrastructure changes
4. Always review the plan before applying
5. Use workspaces for multiple environments
6. Tag all resources appropriately for cost tracking
7. Enable logging and monitoring for both clusters
8. Implement network policies for security

## Cost Optimization

- Use spot/preemptible instances for non-production workloads
- Implement auto-scaling for node groups
- Review and right-size instance types
- Use reserved instances for production workloads
- Monitor and clean up unused resources

## Security Considerations

- Both clusters use managed identities (Azure) and IAM roles (AWS)
- Network isolation via taints and node pools/groups
- Control plane logging enabled for audit trails
- Follow principle of least privilege for IAM/RBAC
- Regularly update Kubernetes versions
- Use private endpoints for production environments

## Troubleshooting

### Azure Issues

```bash
# Check AKS cluster status
az aks show --resource-group az-k8s-rg --name az-k8s-cluster

# View AKS logs
az aks get-credentials --resource-group az-k8s-rg --name az-k8s-cluster
kubectl get nodes
```

### AWS Issues

```bash
# Check EKS cluster status
aws eks describe-cluster --name aws-k8s-cluster --region us-east-1

# View EKS logs
aws eks update-kubeconfig --name aws-k8s-cluster --region us-east-1
kubectl get nodes
```

## License

This infrastructure code is part of the e-commerce microservices project.

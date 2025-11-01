# ecommerce-microservice-infrastructure

Infrastructure as Code (IaC) for the e-commerce microservices project using Terraform with modular architecture.

## Project Structure

```
infrastructure/
├── main.tf                    # Main file that orchestrates the modules
├── variables.tf               # Variable definitions
├── outputs.tf                 # Project outputs
├── providers.tf               # Provider configuration
└── modules/                   # Reusable modules
    ├── resource-group/        # Resource Group module
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    ├── aks-cluster/           # AKS Cluster module
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── README.md
    └── aks-node-pool/         # Node Pools module
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── README.md
```

## Architecture

This project creates the following infrastructure in Azure:

- **Resource Group**: Logical container for resources
- **AKS Cluster**: Kubernetes cluster with default node pool (system)
- **Production Node Pool**: Dedicated node pool for production with taints
- **Dev/Stage Node Pool**: Node pool for development and staging with taints

### Features

- Reusable modular architecture
- Environment separation using node pools with taints
- Parameterized variables
- Outputs for integration with other tools

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured
- Active Azure subscription

## Usage

### 1. Azure Authentication

```bash
az login
```

### 2. Configure Variables

Copy the example file and adjust the values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific values.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Apply the Infrastructure

```bash
terraform apply
```

### 6. Get Kubeconfig

```bash
az aks get-credentials --resource-group az-k8s-rg --name az-k8s-cluster
```

## Main Variables

| Variable            | Description        | Default        |
| ------------------- | ------------------ | -------------- |
| resource_group_name | Resource group name| az-k8s-rg      |
| location            | Azure region       | East US 2      |
| cluster_name        | AKS cluster name   | az-k8s-cluster |
| dns_prefix          | DNS prefix         | aksmultienv    |

See [variables.tf](variables.tf) for the complete list of variables.

## Outputs

After applying the configuration, you can get the outputs:

```bash
terraform output
```

Sensitive outputs (like kubeconfig):

```bash
terraform output -raw kube_config > ~/.kube/config
```

## Modules

Each module is independent and reusable:

- **[resource-group](modules/resource-group/README.md)**: Creates resource groups
- **[aks-cluster](modules/aks-cluster/README.md)**: Creates AKS clusters
- **[aks-node-pool](modules/aks-node-pool/README.md)**: Creates additional node pools

## Modular Structure

Modules provide:

- Code reusability
- Easier maintenance
- Independent testing
- Module versioning
- Flexible infrastructure composition

## Clean Up Resources

To destroy all infrastructure:

```bash
terraform destroy
```

## Best Practices

1. Never commit `terraform.tfvars` with sensitive values
2. Use remote backend for state (e.g., Azure Storage)
3. Implement CI/CD for infrastructure changes
4. Always review the plan before applying
5. Use workspaces for multiple environments

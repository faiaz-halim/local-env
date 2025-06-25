# Secure EKS Cluster Module

## Purpose

This Terraform module simplifies the creation of a production-ready, secure, and cost-effective Amazon EKS cluster for enterprise use.

It acts as a strategic, opinionated wrapper around the official [`terraform-aws-modules/eks/aws`](https://github.com/terraform-aws-modules/terraform-aws-eks) module. It enforces best practices for security, reliability, and governance by default, reducing cognitive load on development teams.

## Key Design Principles & Features

*   ✅ **Security-First by Default**:
    *   **Private API Endpoint**: The Kubernetes API is not exposed to the public internet.
    *   **IRSA Enabled**: IAM Roles for Service Accounts (IRSA) is enabled by default for secure, keyless authentication from pods to AWS services.
    *   **Encrypted by Default**: EBS volumes for nodes are encrypted.
    *   **Network Policies Enforced**: The VPC CNI add-on is configured to enable Kubernetes network policies out-of-the-box.

*   ✅ **Cost-Optimized**:
    *   Easily create a mix of On-Demand and Spot instances via a simple `use_spot_instances` flag in the node group definition.

*   ✅ **Simplified Developer Experience**:
    *   Abstracts hundreds of potential inputs into a few key, high-level decisions.
    *   Provides a simple, map-based interface for defining node groups.
    *   Includes robust input validation to prevent common misconfigurations.

*   ✅ **Dependency Aware**: This module pins to a specific major version of the underlying `terraform-aws-eks` module (`v20.x`) to ensure compatibility with modern Kubernetes versions (like `1.29`) and provide predictable behavior.

## Usage Example

```hcl
module "eks_cluster" {
  source = "../../modules/eks"

  cluster_name        = "dev-test"
  vpc_id              = "vpc-0123456789abcdef0"
  private_subnet_ids  = ["subnet-0a1b2c", "subnet-0d1e2f", "subnet-0g1h2i"]

  # Define your node groups with a simple map
  node_groups = {
    core_services = {
      instance_type = "m5.large"
      min_size      = 2
      desired_size  = 2
      max_size      = 5
      disk_size     = 50
    },
    spot_workers = {
      instance_type      = "m5.large"
      min_size           = 1
      max_size           = 10
      use_spot_instances = true # Cost savings
    }
  }

  tags = {
    Project     = "local-env"
    Environment = "dev-test"
    Owner       = "faiaz-halim"
  }
}
```

Here is a basic example of how to use the module to deploy a production-ready EKS cluster. The module requires you to provide your existing network infrastructure (VPC and Subnets).

```hcl
module "production_cluster" {
  source = "./modules/my-eks-module" # Or use a Git source

  cluster_name = "prod-eks-demo"
  vpc_id       = "vpc-0123456789abcdef0"
  subnet_ids   = ["subnet-0123abc", "subnet-4567def", "subnet-8901ghi"]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "Showcase"
  }
}
```

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | `~> 1.6`  |
| aws       | `~> 5.0`  |

## Providers

| Name      | Version    |
| --------- | ---------- |
| aws       | `~> 5.0`     |
| kubernetes| `~> 2.23`    |
| helm      | `~> 2.11`    |

## Inputs

The following table lists the configurable variables for this module and their default values.

| Name                 | Description                                                                                                                                                             | Type           | Default  | Required |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------- | :------: |
| `cluster_name`       | The unique name of the EKS cluster.                                                                                                                                     | `string`       | n/a      |   yes    |
| `vpc_id`             | The ID of the VPC where the cluster and its nodes will be deployed.                                                                                                     | `string`       | n/a      |   yes    |
| `subnet_ids`         | A list of subnet IDs where the EKS cluster and worker nodes can be placed.                                                                                              | `list(string)` | n/a      |   yes    |
| `kubernetes_version` | The Kubernetes version to deploy. Defaults to the latest stable version supported by AWS EKS. This is validated by the underlying AWS module against supported versions. | `string`       | `"1.31"` |    no    |
| `tags`               | A map of tags to apply to all resources created by the module.                                                                                                          | `map(string)`  | `{}`     |    no    |

## Outputs

The following outputs are exported by the module.

| Name                        | Description                                                                                  |
| --------------------------- | -------------------------------------------------------------------------------------------- |
| `cluster_endpoint`          | The endpoint for your EKS Kubernetes API server, used to connect with `kubectl`.             |
| `cluster_oidc_issuer_url`   | The OIDC issuer URL for the EKS cluster, used for configuring IAM roles for service accounts.  |
| `cluster_security_group_id` | The primary security group ID for the EKS cluster, useful for network rule configuration.    |
| `configure_kubectl`         | A shell command that can be run to configure `kubectl` to connect to the new EKS cluster. |

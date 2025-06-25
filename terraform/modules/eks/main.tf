locals {
  eks_managed_node_groups = {
    for name, config in var.node_groups : name => {
      instance_types = [config.instance_type]
      min_size       = lookup(config, "min_size", 1)
      desired_size   = lookup(config, "desired_size", 1)
      max_size       = lookup(config, "max_size", 3)
      disk_size      = lookup(config, "disk_size", 30)

      capacity_type = lookup(config, "use_spot_instances", false) ? "SPOT" : "ON_DEMAND"

      ami_type = lookup(config, "ami_type", "AL2_x86_64")
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = lookup(config, "disk_size", 30)
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids

  # ##################################################################
  # # SECURITY CONFIGURATION
  # ##################################################################
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  enable_irsa = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
      configuration_values = jsonencode({
        enableNetworkPolicy = "true"
        # enable_pod_eni      = "true"
      })
    }
  }

  eks_managed_node_groups = local.eks_managed_node_groups

  tags = var.tags
}

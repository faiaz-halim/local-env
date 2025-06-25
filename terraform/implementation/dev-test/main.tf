data "aws_vpc" "existing" {
  default = true
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name        = "dev-test-cluster"
  kubernetes_version  = "1.31"
  vpc_id              = data.aws_vpc.existing.id
  private_subnet_ids  = slice(data.aws_subnets.private.ids, 0, 3)

  node_groups = {
    core_services = {
      instance_type = "t3.medium"
      min_size      = 2
      desired_size  = 2
      max_size      = 3
      disk_size     = 30
    },
    spot_workers = {
      instance_type      = "t3.medium"
      min_size           = 1
      max_size           = 5
      use_spot_instances = true
    }
  }

  tags = {
    Project     = "local-env"
    Environment = "dev-test"
    Owner       = "Faiaz Halim"
  }
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

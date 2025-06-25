output "cluster_endpoint" {
  description = "The endpoint for EKS Kubernetes API server (private)."
  value       = module.eks.cluster_endpoint
}

output "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL, used for configuring IAM Roles for Service Accounts."
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_security_group_id" {
  description = "The ID of the primary EKS cluster security group, useful for networking."
  value       = module.eks.cluster_security_group_id
}

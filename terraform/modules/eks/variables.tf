variable "cluster_name" {
  description = "The unique name for the EKS cluster. Used to prefix all resources."
  type        = string
  validation {
    condition     = length(var.cluster_name) > 0 && length(var.cluster_name) < 40
    error_message = "Cluster name must be between 1 and 40 characters."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC where the cluster will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of PRIVATE subnet IDs for nodes and the control plane. Must provide at least 2 for HA."
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnet IDs must be provided for a highly available cluster."
  }
}

variable "kubernetes_version" {
  description = "The Kubernetes version to deploy. Defaults to a recent, stable version."
  type        = string
  default     = "1.31"
}

variable "node_groups" {
  description = "A map defining the managed node groups to create. See README for structure."
  type        = any
  default     = {}
}

variable "tags" {
  description = "A map of tags to apply to all resources. Tags are inherited by all child resources."
  type        = map(string)
  default     = {}
}

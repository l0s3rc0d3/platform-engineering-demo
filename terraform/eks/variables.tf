variable "github_project" {
  type        = string
  description = "Url of the terraform project"
}

variable "sdlc_env" {
  type        = string
  description = "Environment name for the software development lifecycle"
}

variable "aws_region" {
  type        = string
  description = "Aws region"
}

variable "eks_name" {
  type        = string
  description = "Aws eks cluster name"
}

variable "eks_version" {
  type        = string
  description = "Aws eks cluster version"
}

variable "vpc_name" {
  type        = string
  description = "Aws vpc name where the cluster will be created"
}

variable "eks_controlplane_whitelist" {
  type        = list(string)
  description = "Eks subnet whitelist to enable reachability"
}

variable "vpc_eks_subnets" {
  type        = list(string)
  description = "Aws vpc eks subnets"
}

variable "eks_cluster_admins" {
  type        = list(string)
  description = "Aws eks cluster admins iam role/users arn to populate access_entries"
}

variable "eks_managed_node_groups" {
  type = map(object({
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
    labels         = map(string)
    taints         = map(object({
      key    = string
      value  = string
      effect = string
    }))
  }))
  description = "Aws eks managed node groups for platform engineering team"
}
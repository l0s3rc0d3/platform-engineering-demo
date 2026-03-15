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
  description = "Aws eks cluster name to target for addons installation"
}

variable "gitops_branch" {
  type        = string
  description = "Git branch to use for gitops resources"
  default     = "main"
}

variable "dns_public_zone" {
  type        = string
  description = "This will be the public zone managed by external dns application, and will be kept private for privacy and passed as a secret to argocd gitops part"
  sensitive   = true
}
variable "github_project" {
  type        = string
  description = "Url of the terraform project"
}

variable "github_gitops_project" {
  type        = string
  description = "Url of the gitops project"
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

# variable "github_gitops_repo_pat" {
#   type        = string
#   description = "GitHub Personal Access Token for ArgoCD private repo access"
#   sensitive   = true
# }
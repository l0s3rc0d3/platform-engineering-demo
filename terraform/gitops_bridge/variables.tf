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
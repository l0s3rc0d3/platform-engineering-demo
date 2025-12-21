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

variable "vpc_name" {
  type        = string
  default     = ""
  description = "Aws vpc name"
}

variable "vpc_primary_cidr" {
  type        = string
  description = "Aws primary vpc cidr"
}

variable "vpc_secondary_cidr" {
  type        = list(string)
  description = "Aws secondary vpc cidr (used for eks cluster)"
}

variable "vpc_availability_zones" {
  type        = list(string)
  description = "Aws availability zones"
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "Aws vpc public subnets"
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "Aws vpc private subnets"
}

variable "vpc_eks_pods_subnets" {
  type        = list(string)
  description = "Aws vpc eks subnets"
}

variable "vpc_database_subnets" {
  type        = list(string)
  description = "Aws vpc database subnets"
}

variable "vpc_karpenter_tag" {
  type        = string
  description = "Tag used by karpenter discovery related to the eks cluster"
}








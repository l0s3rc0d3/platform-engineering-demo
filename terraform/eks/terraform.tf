terraform {
  required_version = "1.14.2"

  # this is not an s3 bucket + dynamodb table on purpose
  # and should be managed with a separate file stored under backend to use -backend-config flag with terraform init command
  backend "local" {
    path = "/home/xxxxx/documents/tf_state/eks/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "demo"

  default_tags {
    tags = {
      Project        = "${var.sdlc_env} - eks"
      Environment    = "${var.sdlc_env}"
      ManagedBy      = "Terraform"
      Owner          = "Platform engineering team"
      Github_Project = var.github_project
    }
  }
}
terraform {
  required_version = "1.14.2"

  cloud {

    organization = "l0s3rc0d3"

    workspaces {
      name = "demo-eks"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

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
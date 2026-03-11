terraform {
  required_version = "1.14.2"

  cloud { 
    
    organization = "l0s3rc0d3" 

    workspaces { 
      name = "demo-alz" 
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
  region  = var.aws_region

  default_tags {
    tags = {
      Project        = "${var.sdlc_env} - alz"
      Environment    = "${var.sdlc_env}"
      ManagedBy      = "Terraform"
      Owner          = "Platform engineering team"
      Github_Project = var.github_project
    }
  }
  # this is necessary to manage a conflict between tags added via the resource and the tags 
  # added by default
  ignore_tags {
    keys = ["SubnetTier"]
  }
}
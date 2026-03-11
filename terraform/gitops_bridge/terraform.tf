terraform {
  required_version = "1.14.2"

  cloud { 
    
    organization = "l0s3rc0d3" 

    workspaces { 
      name = "demo-gitops_bridge" 
    } 
  } 

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

provider "aws" {
  region  = var.aws_region

  default_tags {
    tags = {
      Project        = "${var.sdlc_env} - addons"
      Environment    = "${var.sdlc_env}"
      ManagedBy      = "Terraform"
      Owner          = "Platform engineering team"
      Github_Project = var.github_project
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
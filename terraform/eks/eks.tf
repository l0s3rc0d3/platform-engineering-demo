module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.1"

  name               = var.eks_name
  kubernetes_version = var.eks_version

  vpc_id                   = data.aws_vpc.this.id
  subnet_ids               = data.aws_subnets.eks_node_subnets.ids
  control_plane_subnet_ids = data.aws_subnets.eks_node_subnets.ids

  endpoint_public_access       = true
  endpoint_private_access      = true
  endpoint_public_access_cidrs = var.eks_controlplane_whitelist

  enable_irsa = true

  authentication_mode = "API"

  access_entries = { for arn in var.eks_cluster_admins :
    element(split("/", arn), length(split("/", arn)) - 1) => {
      principal_arn = arn
      policy_associations = {
        admin = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }

  eks_managed_node_groups = { for name, config in var.eks_managed_node_groups :
    name => merge(config, {
      subnet_ids = data.aws_subnets.eks_node_subnets.ids
    })
  }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.1"

  name               = var.eks_name
  kubernetes_version = var.eks_version

  vpc_id                   = data.aws_vpc.this.id
  subnet_ids               = data.aws_subnets.eks_subnets.ids
  control_plane_subnet_ids = data.aws_subnets.eks_subnets.ids

  endpoint_public_access       = true
  endpoint_private_access      = true
  endpoint_public_access_cidrs = var.eks_controlplane_whitelist

  timeouts = {
    create = "20m"
    update = "20m"
    delete = "20m"
  }

  compute_config = {
    enabled = false
  }

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
      subnet_ids = data.aws_subnets.eks_subnets.ids
    })
  }

  addons = {
    coredns = {
      most_recent = true
      resolve_conflicts_on_create = "OVERWRITE" # this could be useful to overcome order of apply of resources
      resolve_conflicts_on_update = "OVERWRITE" # this could be useful to overcome issues during the updates 
      # union of tolerations default one with custom one
      configuration_values = jsonencode({
        tolerations = concat(local.addon_tolerations, [
          {
            key      = "node.kubernetes.io/not-ready"
            operator = "Exists"
            effect   = "NoSchedule"
          }
        ])
      })
    }
    kube-proxy = {
      most_recent = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      # we dont need to pass toleration here cause kube-proxy by default has: 
      # tolerations: 
      #   - operator: Exists 
      # that works like a wildcard
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      # union of tolerations default one with custom one
      configuration_values = jsonencode({
        # This could be useful to enhance the number of pods schedulable on a single node cause max pods are 18
        # for the purpose of this demo i leave this commented out
        # env = {
        #   ENABLE_PREFIX_DELEGATION = "true"
        # }
        tolerations = concat(local.addon_tolerations, [
          {
            key      = "node.kubernetes.io/not-ready"
            operator = "Exists"
            effect   = "NoSchedule"
          },
          {
            key      = "node.kubernetes.io/unreachable"
            operator = "Exists"
            effect   = "NoSchedule"
          }
        ])
      })
    }
  }
}
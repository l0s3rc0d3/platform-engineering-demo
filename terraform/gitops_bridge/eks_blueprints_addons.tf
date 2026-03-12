module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.23.0"

  cluster_name      = data.aws_eks_cluster.cluster.name
  cluster_endpoint  = data.aws_eks_cluster.cluster.endpoint
  cluster_version   = data.aws_eks_cluster.cluster.version
  oidc_provider_arn = data.aws_iam_openid_connect_provider.this.arn

  enable_external_secrets             = true
  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    namespace = "aws-load-balancer-controller" # namespace override otherwise will be placed inside kube-system
  }

  # this flag is needed to delegate resource creation to argocd
  create_kubernetes_resources = false
}
module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.23.0"

  cluster_name      = data.aws_eks_cluster.cluster.name
  cluster_endpoint  = data.aws_eks_cluster.cluster.endpoint
  cluster_version   = data.aws_eks_cluster.cluster.version
  oidc_provider_arn = data.aws_iam_openid_connect_provider.this.arn

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    namespace            = "aws-load-balancer-controller" # namespace override otherwise will be placed inside kube-system and i want specific namespace for each component
    service_account_name = "aws-load-balancer-controller" # have to match serviceAccount.name in values.yaml cause the trust relationship created with -sa name at the end
  }

  enable_external_dns = true
  external_dns = {
    namespace            = "external-dns"
    service_account_name = "external-dns"
  }
  external_dns_route53_zone_arns = [data.aws_route53_zone.public.arn]

  enable_external_secrets = true
  external_secrets = {
    namespace            = "external-secrets"
    service_account_name = "external-secrets"
  }

  # this flag is needed to delegate resource creation to argocd
  create_kubernetes_resources = false
}
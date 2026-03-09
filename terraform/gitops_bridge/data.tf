data "aws_eks_cluster" "cluster" {
  name = var.eks_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_name
}

data "aws_vpc" "selected" {
  id = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
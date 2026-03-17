# This should work as a bridge between Terraform and ArgoCD
# Annotation are populated by gitops_metadata by eks-blueprints-addons and these contains all the ARN created with key-value pair
# labels enable ApplicationSet that are active for a certain cluster
resource "kubernetes_secret_v1" "argocd_cluster_metadata" {
  metadata {
    name      = "${var.eks_name}-cluster-metadata"
    namespace = "argocd"

    # Labels used as selectors in ApplicationSet to enable/disable addon for specific clusters
    labels = {
      "argocd.argoproj.io/secret-type"      = "cluster" # this label enable argo to load this secret
      "enable_external_secrets"             = "true"    # this enable the gitops modularity feature and you can choose which addon to enable 
      "enable_aws_load_balancer_controller" = "true"
      "enable_external_dns"                 = "true"
      "enable_platform_public_ingress"      = "true"
    }

    # Annotations are read by argocd and contains infra values produced by terraform
    # are read by applicationSet trought {{metadata.annotations.*}}
    annotations = merge(
      module.eks_blueprints_addons.gitops_metadata,
      {
        environment           = var.sdlc_env
        aws_cluster_name      = var.eks_name
        aws_region            = var.aws_region
        aws_vpc_id            = data.aws_vpc.selected.id
        dns_public_zone       = var.dns_public_zone
        acm_certificate_arn   = aws_acm_certificate.wildcard.arn
        alb_security_group_id = data.aws_security_group.alb_shared.id
      }
    )
  }

  # the following tell argo how to connect to the cluster
  data = {
    name   = "in-cluster"
    server = "https://kubernetes.default.svc" # this parameter is used inside each application set!
    config = jsonencode({ tlsClientConfig = { insecure = false } })
  }

  depends_on = [helm_release.argocd]
}
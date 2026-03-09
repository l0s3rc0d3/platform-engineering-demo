resource "random_password" "argocd_admin" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "argocd_admin" {
  name                    = "${var.sdlc_env}-argocd-admin-pwd"
  description             = "Admin password for argoCD inside ${var.eks_name} eks cluster"
  recovery_window_in_days = 0 # This is set up to 0 cause this is a demo and i destory the project every time that i'm not working on it
}

resource "aws_secretsmanager_secret_version" "argocd_admin" {
  secret_id     = aws_secretsmanager_secret.argocd_admin.id
  secret_string = random_password.argocd_admin.result
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.4.7"
  namespace        = "argocd"
  create_namespace = true

  values = [
    file("${path.module}/yaml/argocd/override.${var.sdlc_env}.yaml")
  ]

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt(random_password.argocd_admin.result)
  }
}
# i chose to manage the authentication between argo and github in this way because 
# in this stage of the infra i don't have a secret provider inside the cluster yet
# and i want to manage every application trought argocd

# and this part is meant to be temporary also cause i'll need this only because while 
# i work on the yaml i want to keep them privates then i can switch the repo to public

# NOW THE REPO IS PUBLIC

# resource "aws_secretsmanager_secret" "argocd_repo_pat" {
#   name                    = "${var.sdlc_env}-${var.eks_name}-argocd-repo-pat"
#   description             = "GitHub PAT for ArgoCD private repo"
#   recovery_window_in_days = 0
# }

# resource "aws_secretsmanager_secret_version" "argocd_repo_pat" {
#   secret_id     = aws_secretsmanager_secret.argocd_repo_pat.id
#   secret_string = var.github_gitops_repo_pat
# }

# resource "kubernetes_secret_v1" "argocd_repo" {
#   metadata {
#     name      = "argocd-repo-platform-engineering"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repository"
#     }
#   }

#   data = {
#     type     = "git"
#     url      = var.github_gitops_project
#     username = "x-access-token"
#     password = var.github_gitops_repo_pat
#   }

#   depends_on = [helm_release.argocd]
# }
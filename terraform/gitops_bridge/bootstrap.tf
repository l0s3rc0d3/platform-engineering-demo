resource "helm_release" "platform_engineering_bootstrap" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.4"
  namespace  = "argocd"

  values = [
    <<-EOT
    applications:
      platform-engineering-bootstrap:
        namespace: argocd
        finalizers:
          - resources-finalizer.argocd.argoproj.io
        project: default
        source:
          repoURL: ${var.github_gitops_project}
          targetRevision: HEAD
          path: bootstrap/${var.sdlc_env}
        destination:
          server: https://kubernetes.default.svc
          namespace: argocd
        syncPolicy:
          automated:
            prune: true
            selfHeal: true
          syncOptions:
            - CreateNamespace=true
    EOT
  ]

  depends_on = [helm_release.argocd]
}
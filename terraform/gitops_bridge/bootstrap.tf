resource "helm_release" "platform_engineering_bootstrap" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.4"
  namespace  = "argocd"

  values = [
    <<-EOT
    applicationsets:
      platform-apps:
        namespace: argocd
        generators:
          - matrix:
              generators:
                - git:
                    repoURL: ${var.github_project}
                    revision: ${var.gitops_branch}
                    directories:
                      - path: gitops/helm/*
                - list:
                    elements:
                      - env: ${var.sdlc_env}
        template:
          metadata:
            name: "{{path.basename}}"
            namespace: argocd
            finalizers:
              - resources-finalizer.argocd.argoproj.io
          spec:
            project: default
            source:
              repoURL: ${var.github_project}
              targetRevision: ${var.gitops_branch}
              path: "{{path}}"
              helm:
                ignoreMissingValueFiles: true
                valueFiles:
                  - values.yaml
                  - ./overrides/override.{{env}}.yaml
            destination:
              server: https://kubernetes.default.svc
              namespace: "{{path.basename}}"
            syncPolicy:
              automated:
                prune: true
                selfHeal: true
              syncOptions:
                - CreateNamespace=true
                - ServerSideApply=true
              retry:
                limit: 3
                backoff:
                  duration: 30s
                  factor: 2
                  maxDuration: 5m
    EOT
  ]

  depends_on = [helm_release.argocd]
}
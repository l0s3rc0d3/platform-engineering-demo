resource "helm_release" "platform_engineering_bootstrap" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.4"
  namespace  = "argocd"

  values = [
    <<-EOT
    applicationsets:

      external-secrets:
        namespace: argocd
        generators:
          - clusters:
              selector:
                matchLabels:
                  enable_external_secrets: "true"
        template:
          metadata:
            name: "addon-{{name}}-external-secrets"
            namespace: argocd
            finalizers:
              - resources-finalizer.argocd.argoproj.io
          spec:
            project: default
            source:
              repoURL: ${var.github_project}
              targetRevision: ${var.gitops_branch}
              path: gitops/addons/external-secrets
              helm:
                ignoreMissingValueFiles: true
                valueFiles:
                  - values.yaml
                  - ./overrides/override.{{metadata.annotations.environment}}.yaml
                parameters:
                  - name: "external-secrets.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
                    value: "{{metadata.annotations.external_secrets_iam_role_arn}}"
            destination:
              server: "{{server}}"
              namespace: external-secrets
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

      aws-load-balancer-controller:
        namespace: argocd
        generators:
          - clusters:
              selector:
                matchLabels:
                  enable_aws_load_balancer_controller: "true"
        template:
          metadata:
            name: "addon-{{name}}-aws-load-balancer-controller"
            namespace: argocd
            finalizers:
              - resources-finalizer.argocd.argoproj.io
          spec:
            project: default
            source:
              repoURL: ${var.github_project}
              targetRevision: ${var.gitops_branch}
              path: gitops/addons/aws-load-balancer-controller
              helm:
                ignoreMissingValueFiles: true
                valueFiles:
                  - values.yaml
                  - ./overrides/override.{{metadata.annotations.environment}}.yaml
                parameters:
                  - name: "aws-load-balancer-controller.clusterName"
                    value: "{{metadata.annotations.aws_cluster_name}}"
                  - name: "aws-load-balancer-controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
                    value: "{{metadata.annotations.aws_load_balancer_controller_iam_role_arn}}"
            destination:
              server: "{{server}}"
              namespace: aws-load-balancer-controller
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
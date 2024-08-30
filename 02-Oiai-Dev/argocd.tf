locals {
  argo_cd_subdomain = "*"
}

module "argocd_irsa_access" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role  = true
  role_name    = "argocd-role"
  provider_url = local.main_cluster.cluster_oidc_issuer_url
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  ]
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:*"
  ]
}

module "argocd_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = "argocd.${local.zone_name}"
  zone_id     = local.zone_id


  validation_method = "DNS"

  wait_for_validation = true

  tags = {
    Name = "argocd.${local.zone_name}"
  }
}
module "argo_cd" {
  source = "../modules/argocd"

  domain          = "argocd.${local.zone_name}"
  certificate_arn = module.argocd_acm.acm_certificate_arn
  role_arn        = module.argocd_irsa_access.iam_role_arn

  depends_on = [kubernetes_secret.docker_hub_secret]
}


resource "kubernetes_manifest" "argocd_image_updater" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "argocd-image-updater"
      namespace = "argo-cd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://argoproj.github.io/argo-helm"
        chart          = "argocd-image-updater"
        targetRevision = "*"
        helm = {
          values = yamlencode({
            config = {
              registries = [
                {
                  api_url     = "https://132900311735.dkr.ecr.us-east-1.amazonaws.com"
                  credentials = "ext:/scripts/ecr-login.sh"
                  credsexpire = "12h"
                  default     = true
                  insecure    = false
                  name        = "ECR"
                  ping        = true
                  prefix      = "132900311735.dkr.ecr.us-east-1.amazonaws.com"
                }
              ]
              serverAddress = "https://argo-cd-argocd-server.argocd"
            }
            serviceAccount = {
              create = true
              annotations = {
                "eks.amazonaws.com/role-arn" = module.argocd_irsa_access.iam_role_arn
              }
              name = "argocd-image-updater"
            }
            authScripts = {
              enabled = true
              scripts = {
                "ecr-login.sh" = <<EOF
#!/bin/sh
HOME=/tmp aws ecr --region us-east-1 get-authorization-token --output text --query 'authorizationData[].authorizationToken' | base64 -d
EOF
              }

            }
          })
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argo-cd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }
  field_manager {
    force_conflicts = true
  }

  depends_on = [module.argo_cd]
}
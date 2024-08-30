locals {
  argocd-project-name = "oiai-dev-project"
  argo_cd_subdomain   = "api"
}

module "api_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = "${local.argo_cd_subdomain}.${local.zone_name}"
  zone_id     = local.zone_id

  validation_method = "DNS"

  wait_for_validation = true

  tags = {
    Name = "${local.argo_cd_subdomain}.${local.zone_name}"
  }
}

resource "kubernetes_manifest" "oiai_dev_project" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AppProject"
    metadata = {
      name      = local.argocd-project-name
      namespace = "argo-cd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
      annotations = {
      }
    }
    spec = {
      clusterResourceWhitelist = [
        {
          group = "*"
          kind  = "*"
        }
      ]
      destinations = [
        {
          namespace = "*"
          server    = "https://kubernetes.default.svc"
        }
      ]
      sourceRepos = [
        "*"
      ]
    }
  }
}

resource "kubernetes_manifest" "api" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "api-dev"
      namespace = "argo-cd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
      annotations = {
        "argocd-image-updater.argoproj.io/image-list"          = "api=132900311735.dkr.ecr.us-east-1.amazonaws.com/oiai-dev-us-east-1-api-repo:development"
        "argocd-image-updater.argoproj.io/api.update-strategy" = "digest"
        "argocd-image-updater.argoproj.io/api.helm.image-spec" = "api.image"
        "argocd-image-updater.argoproj.io/api.pull-secret"     = "pullsecret:argo-cd/dpr-secret"
        "argocd-image-updater.argoproj.io/api.force-update"    = "true"
        "argocd-image-updater.argoproj.io/write-back-method"   = "git:secret:argo-cd/oiai-api-dev-chart-git-credentials"
      }
    }
    spec = {
      project = local.argocd-project-name
      source = {
        repoURL        = "https://github.com/fabian818/oiai-api-dev-chart"
        path           = "."
        targetRevision = "main"
        helm = {
          parameters = [
            {
              name  = "appRevision"
              value = "$ARGOCD_APP_REVISION"
            }
          ]
          values = yamlencode({
            api = {
              databaseSecret = "oiai-db-credentials-secret"
              alb = {
                certificateArn = module.api_acm.acm_certificate_arn
              }
            }
          })
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "apps"
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
}

data "aws_secretsmanager_secret" "github_token" {
  name = "dev/oiai/api/github-token"
}

data "aws_secretsmanager_secret_version" "github_token_version" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}

resource "kubernetes_secret" "argocd_git_credentials_api_dev_chart" {
  metadata {
    name      = "oiai-api-dev-chart-git-credentials"
    namespace = "argo-cd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  data = {
    "type"     = "git"
    "url"      = "https://github.com/fabian818/oiai-api-dev-chart"
    "username" = "fabian818"
    "password" = data.aws_secretsmanager_secret_version.github_token_version.secret_string
  }
}



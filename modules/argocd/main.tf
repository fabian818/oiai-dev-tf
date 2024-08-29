resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argo-cd"
  chart      = "argo-cd"
  version    = var.version_argo_cd

  values = [
    "${templatefile("${path.module***REMOVED***/values-argo-cd.yaml",
      {
        domain = var.domain,
        certificate_arn = var.certificate_arn
    ***REMOVED***)***REMOVED***"
***REMOVED***
***REMOVED***

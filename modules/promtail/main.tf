resource "helm_release" "promtail" {
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = "monitoring"
  chart      = "promtail"
  version    = var.version_promtail

  set {
    name  = "config.clients[0].url"
    value = var.client_url
  }

  set {
    name  = "config.clients[0].external_labels.cluster"
    value = var.cluster_name
  }

  set {
    name  = "config.clients[0].tenant_id"
    value = var.tenant_id
  }
}

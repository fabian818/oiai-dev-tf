terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
    }
  }
}

provider "grafana" {
  url     = "https://grafana.oiai.thisguydeploys.com/"
  auth    = "admin:${data.aws_secretsmanager_secret_version.grafana_password_version.secret_string}"
}


resource "grafana_data_source" "prometheus" {
  type                = "prometheus"
  name                = "prometheus"
  url                 = "http://kube-prometheus-prometheus.monitoring.svc.cluster.local:9090"
  basic_auth_enabled  = false

  json_data_encoded = jsonencode({
    httpMethod        = "POST"
  })
}


resource "grafana_dashboard" "multi_cluster_kubernetes_metrics" {
  config_json = templatefile("${path.module}/grafana-dashboards/multi-cluster-eks-metrics.json",
    {
      datasource_uid=grafana_data_source.prometheus.uid
    })
}
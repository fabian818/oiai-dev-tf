resource "kubernetes_config_map" "grafana_ini" {
  metadata {
    name = "grafana-ini-configmap"
    namespace = "monitoring"
  }

  data = {
    "grafana.ini" = <<-EOF
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: grafana-ini-configmap
      data:
        grafana.ini: |
          [server]
          root_url = https://grafana.oiai.thisguydeploys.com
    EOF
  }
}


data "aws_secretsmanager_secret" "grafana_password" {
  name = "dev/oiai/grafana/password"
}

data "aws_secretsmanager_secret_version" "grafana_password_version" {
  secret_id = data.aws_secretsmanager_secret.grafana_password.id
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  namespace  = "monitoring"
  chart      = "grafana"
  version    = "9.8.3"

  values = [
    "${templatefile("${path.module}/values.yaml",
    {
      config_map=kubernetes_config_map.grafana_ini.metadata[0].name,
      password=data.aws_secretsmanager_secret_version.grafana_password_version.secret_string,
    })}"
  ]
}
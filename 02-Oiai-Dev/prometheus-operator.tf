module "prometheus_operator" {
  source = "../modules/prometheus-operator"

  cluster_name                = local.main_cluster.cluster_name
  provider_url                = local.main_cluster.cluster_oidc_issuer_url
  version_prometheus_operator = "8.25.8"
  region                      = local.default_region
  bucket_name                 = "monitoring-us-east-1-thanos-bucket-bucket"
***REMOVED***

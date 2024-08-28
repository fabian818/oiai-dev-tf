resource "aws_iam_policy" "thanos_policy" {
  name        = "${var.cluster_name***REMOVED***ThanosPolicy"
  description = "Policy for AWS Load Balancer"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*"
      ***REMOVED***,
        Resource = "*",
      ***REMOVED***
  ***REMOVED***
  ***REMOVED***)
***REMOVED***

module "thanos_irsa_access" {
***REMOVED***
***REMOVED***
  role_name    = "${var.cluster_name***REMOVED***-thanos-role"
  provider_url = var.provider_url
***REMOVED***
    aws_iam_policy.thanos_policy.arn
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***


resource "kubernetes_secret" "thanos_objstore_config" {
***REMOVED***
    name      = "thanos-objstore-config"
    namespace = "monitoring"
  ***REMOVED***

***REMOVED***
    "thanos.yaml" = <<-EOT
      type: s3
      config:
        bucket: ${var.bucket_name***REMOVED***
        region: ${var.region***REMOVED***
        endpoint: s3.${var.region***REMOVED***.amazonaws.com
        aws_sdk_auth: true
    EOT
  ***REMOVED***

  type = "Opaque"
***REMOVED***

resource "helm_release" "prometheus_operator" {
  name       = "kube-prometheus"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  namespace  = "monitoring"
  chart      = "kube-prometheus"
  version    = var.version_prometheus_operator

  values = [
    "${templatefile("${path.module***REMOVED***/values-prometheus.yaml",
    {
      thanos_s3_role_arn=module.thanos_irsa_access.iam_role_arn,
      cluster_name=var.cluster_name
    ***REMOVED***)***REMOVED***"
***REMOVED***
***REMOVED***

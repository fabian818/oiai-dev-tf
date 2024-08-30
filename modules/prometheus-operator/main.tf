resource "aws_iam_policy" "thanos_policy" {
  name        = "${var.cluster_name}ThanosPolicy"
  description = "Policy for AWS Load Balancer"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = "*",
      }
    ]
  })
}

module "thanos_irsa_access" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role  = true
  role_name    = "${var.cluster_name}-thanos-role"
  provider_url = var.provider_url
  role_policy_arns = [
    aws_iam_policy.thanos_policy.arn
  ]
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:*"
  ]
}


resource "kubernetes_secret" "thanos_objstore_config" {
  metadata {
    name      = "thanos-objstore-config"
    namespace = "monitoring"
  }

  data = {
    "thanos.yaml" = <<-EOT
      type: s3
      config:
        bucket: ${var.bucket_name}
        region: ${var.region}
        endpoint: s3.${var.region}.amazonaws.com
        aws_sdk_auth: true
    EOT
  }

  type = "Opaque"
}

resource "helm_release" "prometheus_operator" {
  name       = "kube-prometheus"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  namespace  = "monitoring"
  chart      = "kube-prometheus"
  version    = var.version_prometheus_operator

  values = [
    "${templatefile("${path.module}/values-prometheus.yaml",
      {
        thanos_s3_role_arn = module.thanos_irsa_access.iam_role_arn,
        cluster_name       = var.cluster_name
    })}"
  ]
}

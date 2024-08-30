module "ebs_irsa_access" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role  = true
  role_name    = "ebs-dev-role"
  provider_url = local.main_cluster.cluster_oidc_issuer_url
  role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:*"
  ]
}

resource "kubernetes_service_account" "ebs_sa" {
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = "storage"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.ebs_irsa_access.iam_role_arn
    }
  }
  automount_service_account_token = true
}

resource "helm_release" "ebs" {
  name       = "ebs"
  repository = "https://charts.deliveryhero.io/"
  namespace  = "storage"
  chart      = "aws-ebs-csi-driver"
  version    = "2.17.1"

  set {
    name  = "controller.serviceAccount.create"
    value = "false"
  }
}
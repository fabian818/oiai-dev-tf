module "ebs_irsa_access" {
***REMOVED***
***REMOVED***
  role_name    = "ebs-dev-role"
***REMOVED***
***REMOVED***
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

resource "kubernetes_service_account" "ebs_sa" {
***REMOVED***
    name      = "ebs-csi-controller-sa"
    namespace = "storage"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.ebs_irsa_access.iam_role_arn
    ***REMOVED***
  ***REMOVED***
  automount_service_account_token = true
***REMOVED***

resource "helm_release" "ebs" {
  name       = "ebs"
  repository = "https://charts.deliveryhero.io/"
  namespace  = "storage"
  chart      = "aws-ebs-csi-driver"
  version    = "2.17.1"

  set {
    name  = "controller.serviceAccount.create"
    value = "false"
  ***REMOVED***
***REMOVED***
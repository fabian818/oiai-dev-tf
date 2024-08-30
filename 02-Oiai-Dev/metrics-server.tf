
resource "helm_release" "metrics_server" {
  name       = "aws-load-balancer-controller"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  namespace  = "monitoring"
  chart      = "metrics-server"
***REMOVED***
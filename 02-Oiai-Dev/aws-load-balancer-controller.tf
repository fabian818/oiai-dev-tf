module "aws_load_balancer_controller" {
  source = "../modules/aws-load-controller"

  cluster_name = local.main_cluster.cluster_name
***REMOVED***
  region = local.default_region
***REMOVED***

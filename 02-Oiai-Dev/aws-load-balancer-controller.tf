module "aws_load_balancer_controller" {
  source = "../modules/aws-load-balancer-controller"

  cluster_name = local.main_cluster.cluster_name
***REMOVED***
  region       = local.default_region
  vpc_id       = local.vpc.vpc_id
***REMOVED***

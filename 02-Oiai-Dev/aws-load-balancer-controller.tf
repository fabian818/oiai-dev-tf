module "aws_load_balancer_controller" {
  source = "../modules/aws-load-balancer-controller"

  cluster_name = local.main_cluster.cluster_name
  provider_url = local.main_cluster.cluster_oidc_issuer_url
  region       = local.default_region
  vpc_id       = local.vpc.vpc_id
}

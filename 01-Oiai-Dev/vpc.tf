module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "oiai-dev-vpc"
  cidr = local.vpc_cidr

  azs             = local.vpc_azs
  private_subnets = local.vpc_private_subnets
  public_subnets  = local.vpc_public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  ***REMOVED***

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  ***REMOVED***

  default_security_group_ingress = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    ***REMOVED***
***REMOVED***

  default_security_group_egress = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    ***REMOVED***
***REMOVED***

  tags = local.product_tags
***REMOVED***

locals {

  # Constants

  deletion_protection = false
  resource_prefix     = "oiai-dev"
  aws_region          = "us-east-1"
  default_tags = {
    Owner     = "Devops"
    Env       = "Dev"
    Terraform = "True"
  }
  product_tags = merge(local.default_tags, {
    product = "general"
  })

  # Parameters
  vpc_octet           = 2
  vpc_cidr            = "10.${local.vpc_octet}.0.0/16"
  vpc_azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_private_subnets = ["10.${local.vpc_octet}.1.0/24", "10.${local.vpc_octet}.2.0/24", "10.${local.vpc_octet}.3.0/24"]
  vpc_public_subnets  = ["10.${local.vpc_octet}.101.0/24", "10.${local.vpc_octet}.102.0/24", "10.${local.vpc_octet}.103.0/24"]

  ecr-repos = {
    frontend = {}
    api      = {}
  }
}
***REMOVED***

  # Constants

  deletion_protection = false
  resource_prefix     = "oiai-dev"
  aws_region          = "us-east-1"
  default_tags = {
    Owner     = "Devops"
    Env       = "Dev"
    Terraform = "True"
  ***REMOVED***
  product_tags = merge(local.default_tags, {
    product = "general"
  ***REMOVED***)

  # Parameters
  vpc_octet           = 2
  vpc_cidr            = "10.${local.vpc_octet***REMOVED***.0.0/16"
  vpc_azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_private_subnets = ["10.${local.vpc_octet***REMOVED***.1.0/24", "10.${local.vpc_octet***REMOVED***.2.0/24", "10.${local.vpc_octet***REMOVED***.3.0/24"]
  vpc_public_subnets  = ["10.${local.vpc_octet***REMOVED***.101.0/24", "10.${local.vpc_octet***REMOVED***.102.0/24", "10.${local.vpc_octet***REMOVED***.103.0/24"]

  ecr-repos = {
    frontend = {***REMOVED***
    api = {***REMOVED***
  ***REMOVED***
***REMOVED***
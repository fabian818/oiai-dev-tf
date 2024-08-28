data "aws_caller_identity" "current" {***REMOVED***

module "main_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "oiai-dev"
  cluster_version = "1.30"

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  cluster_endpoint_public_access = true

  cloudwatch_log_group_retention_in_days = 30

  cluster_addons = {
    coredns = {
      most_recent = true
    ***REMOVED***
    kube-proxy = {
      most_recent = true
    ***REMOVED***
    vpc-cni = {
      most_recent = true
    ***REMOVED***
  ***REMOVED***

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type  = "BOTTLEROCKET_x86_64"
    platform  = "bottlerocket"
    disk_size = 50
    update_config = {
      max_unavailable_percentage = 33
    ***REMOVED***
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      AmazonSSMPatchAssociation    = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
    ***REMOVED***
  ***REMOVED***

  eks_managed_node_groups = {
    on-demand-4vcpu-16gb = {
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      min_size       = 2
      max_size       = 3
      desired_size   = 2
      launch_template_tags = {
        "amiFamily" = "bottlerocket"
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***

  # aws-auth configmap
  # create_aws_auth_configmap = false
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "AWSReservedSSO_AdministratorAccess_934ff643f03112d1"
      username = "SSOAdmin"
      groups   = ["system:masters"]
    ***REMOVED***,
    {
      rolearn  = "arn:aws:iam::132900311735:role/AWSReservedSSO_AdministratorAccess_934ff643f03112d1"
      username = "SSOAdmin"
      groups   = ["system:masters"]
    ***REMOVED***,
    {
      rolearn  = aws_iam_role.github_role.arn
      username = "github-actions"
      groups   = ["system:masters"]
    ***REMOVED***
***REMOVED***

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id # dg-sandbox account
***REMOVED***

  tags = local.product_tags
***REMOVED***
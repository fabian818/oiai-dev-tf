resource "aws_iam_policy" "load_balancer_policy" {
  name        = "aws-load-balancer-controller-policy-dev"
  description = "Policy for AWS Load Balancer"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:CreateServiceLinkedRole"
      ***REMOVED***,
        Resource = "*",
        Condition = {
          StringEquals = {
            "iam:AWSServiceName" : "elasticloadbalancing.amazonaws.com"
          ***REMOVED***
        ***REMOVED***
      ***REMOVED***,
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcPeeringConnections",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeTags",
          "ec2:CreateTags",
          "ec2:GetCoipPoolUsage",
          "ec2:DescribeCoipPools",
          "elasticloadbalancing:*"
      ***REMOVED***,
        Resource = "*"
      ***REMOVED***,
      {
        Effect = "Allow",
        Action = [
          "cognito-idp:DescribeUserPoolClient",
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "iam:ListServerCertificates",
          "iam:GetServerCertificate",
          "waf-regional:GetWebACL",
          "waf-regional:GetWebACLForResource",
          "waf-regional:AssociateWebACL",
          "waf-regional:DisassociateWebACL",
          "wafv2:GetWebACL",
          "wafv2:GetWebACLForResource",
          "wafv2:AssociateWebACL",
          "wafv2:DisassociateWebACL",
          "shield:GetSubscriptionState",
          "shield:DescribeProtection",
          "shield:CreateProtection",
          "shield:DeleteProtection"
      ***REMOVED***,
        Resource = "*"
      ***REMOVED***,
      {
        Effect = "Allow",
        Action = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress"
      ***REMOVED***,
        Resource = "*"
      ***REMOVED***,
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateSecurityGroup"
      ***REMOVED***,
        Resource = "*"
      ***REMOVED***,
      {
        Effect = "Allow",
        Action = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DeleteSecurityGroup"
      ***REMOVED***,
        Resource = "*",
        Condition = {
          Null = {
            "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
          ***REMOVED***
        ***REMOVED***
      ***REMOVED***,
      {
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateTargetGroup"
      ***REMOVED***,
        Resource = "*",
        Condition = {
          Null = {
            "aws:RequestTag/elbv2.k8s.aws/cluster" : "false"
          ***REMOVED***
        ***REMOVED***
      ***REMOVED***,
      {
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:DeleteRule"
      ***REMOVED***,
        Resource = "*"
      ***REMOVED***,
      {
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:SetIpAddressType",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:SetSubnets",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:DeleteTargetGroup"
      ***REMOVED***,
        Resource = "*",
        Condition = {
          Null = {
            "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
          ***REMOVED***
        ***REMOVED***
      ***REMOVED***,
      {
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:SetWebAcl",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:AddListenerCertificates",
          "elasticloadbalancing:RemoveListenerCertificates",
          "elasticloadbalancing:ModifyRule"
      ***REMOVED***,
        Resource = "*"
      ***REMOVED***
  ***REMOVED***
  ***REMOVED***)
***REMOVED***

module "aws_load_balancer_controller_role" {
***REMOVED***
***REMOVED***
  role_name    = "aws-load-balancer-controller-role"
  provider_url = var.provider_url
***REMOVED***
    aws_iam_policy.load_balancer_policy.arn
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

resource "kubernetes_service_account" "aws_load_balancer_controller" {
***REMOVED***
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.aws_load_balancer_controller_role.iam_role_arn
    ***REMOVED***
  ***REMOVED***
  automount_service_account_token = true
***REMOVED***

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = var.cluster_name
  ***REMOVED***

  set {
    name  = "serviceAccount.create"
    value = false
  ***REMOVED***

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  ***REMOVED***

  set {
    name  = "region"
    value = var.region
  ***REMOVED***

  set {
    name  = "vpcId"
    value = var.vpc_id
  ***REMOVED***
***REMOVED***
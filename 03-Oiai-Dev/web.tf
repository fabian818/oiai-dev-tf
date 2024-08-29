module "cdn" {
  source = "cloudposse/cloudfront-s3-cdn/aws"

  namespace         = "dg"
  stage             = "dev"
  name              = "oiai-web"
  aliases           = ["web.oiai.thisguydeploys.com"]
  dns_alias_enabled = true
  parent_zone_name  = "oiai.thisguydeploys.com"

***REMOVED***
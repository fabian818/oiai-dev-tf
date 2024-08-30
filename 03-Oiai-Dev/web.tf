module "web" {
  source = "cloudposse/s3-website/aws"

  namespace      = "dg"
  stage          = "dev"
  name           = "oiai-wev"
  hostname       = "web.oiai.thisguydeploys.com"
  parent_zone_id = "Z00811921MTDWQCX2K9UX"

  logs_enabled = false
***REMOVED***
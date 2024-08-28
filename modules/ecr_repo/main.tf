resource "aws_ecr_repository" "default" {
  name                 = "${local.prefix***REMOVED***-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = false
  ***REMOVED***

  tags = merge(var.additional_tags, {
    Name = "${local.prefix***REMOVED***-repo"
  ***REMOVED***)
***REMOVED***

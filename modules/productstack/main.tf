resource "aws_security_group" "productstack_components" {
  for_each = var.components

  name        = "${local.prefix***REMOVED***-${each.key***REMOVED***-sg"
  description = "${local.prefix***REMOVED***-${each.key***REMOVED***-sg"
  vpc_id      = var.vpc_id
  tags = merge(var.additional_tags, {
    Name = "${local.prefix***REMOVED***-${each.key***REMOVED***-sg"
  ***REMOVED***)
***REMOVED***

***REMOVED***
  prefix = "${var.resource_prefix***REMOVED***-${var.aws_region***REMOVED***-${var.component_prefix***REMOVED***"

  ingress_relations = merge([
    for component_key, component in var.components : {
      for ingress_key, ingress in component.ingress :
      "${component_key***REMOVED***-${ingress.source***REMOVED***-${ingress.from***REMOVED***-${ingress.to***REMOVED***" => {
        target_component = component_key
        source           = ingress.source
        from             = ingress.from
        to               = ingress.to
        protocol         = ingress.protocol == null ? "tcp" : ingress.protocol
      ***REMOVED***
    ***REMOVED***
***REMOVED***...)

  egress_relations = merge([
    for component_key, component in var.components : {
      for egress_key, egress in component.egress :
      "${component_key***REMOVED***-${egress.source***REMOVED***-${egress.from***REMOVED***-${egress.to***REMOVED***" => {
        target_component = component_key
        source           = egress.source
        from             = egress.from
        to               = egress.to
        protocol         = egress.protocol == null ? "tcp" : egress.protocol
      ***REMOVED***
    ***REMOVED***
***REMOVED***...)
***REMOVED***

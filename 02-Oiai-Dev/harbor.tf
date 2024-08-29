# resource "helm_release" "promtail" {
#   name       = "harbor"
#   namespace  = "monitoring"

#   set {
#     name  = "config.clients[0].url"
#     value = var.client_url
#   ***REMOVED***

#   set {
#     name  = "config.clients[0].external_labels.cluster"
#     value = var.cluster_name
#   ***REMOVED***

#   set {
#     name  = "config.clients[0].tenant_id"
#     value = var.tenant_id
#   ***REMOVED***
# ***REMOVED***

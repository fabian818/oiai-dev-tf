resource "kubernetes_namespace" "monitoring" {
***REMOVED***
    annotations = {
      name = "monitoring"
    ***REMOVED***

    name = "monitoring"
  ***REMOVED***
***REMOVED***

resource "kubernetes_namespace" "storage" {
***REMOVED***
    annotations = {
      name = "storage"
    ***REMOVED***

    name = "storage"
  ***REMOVED***
***REMOVED***

resource "kubernetes_namespace" "argo_cd" {
***REMOVED***
    annotations = {
      name = "argo-cd"
    ***REMOVED***

    name = "argo-cd"
  ***REMOVED***
***REMOVED***

resource "kubernetes_namespace" "harbor" {
***REMOVED***
    annotations = {
      name = "harbor"
    ***REMOVED***

    name = "harbor"
  ***REMOVED***
***REMOVED***
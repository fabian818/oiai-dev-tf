resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
    }

    name = "monitoring"
  }
}

resource "kubernetes_namespace" "storage" {
  metadata {
    annotations = {
      name = "storage"
    }

    name = "storage"
  }
}

resource "kubernetes_namespace" "argo_cd" {
  metadata {
    annotations = {
      name = "argo-cd"
    }

    name = "argo-cd"
  }
}

resource "kubernetes_namespace" "harbor" {
  metadata {
    annotations = {
      name = "harbor"
    }

    name = "harbor"
  }
}
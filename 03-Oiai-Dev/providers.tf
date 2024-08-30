data "aws_eks_cluster_auth" "cluster" {
  name = local.main_cluster.cluster_name
}

provider "kubernetes" {
  host                   = local.main_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(local.main_cluster.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = local.main_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(local.main_cluster.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
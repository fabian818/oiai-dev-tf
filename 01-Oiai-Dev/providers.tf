terraform {}

data "aws_eks_cluster_auth" "cluster" {
  name = module.main_eks.cluster_name
}

provider "kubernetes" {
  host                   = module.main_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.main_eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
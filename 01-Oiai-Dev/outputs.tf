output "main_cluster" {
  value = module.main_eks
}

output "ecr_repos" {
  value = {
    for k, obj in module.ecr_repos : k => {
      arn            = obj.arn
      repository_url = obj.repository_url
    }
  }
}

output "vpc" {
  value = module.vpc
}
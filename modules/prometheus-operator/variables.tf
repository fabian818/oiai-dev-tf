variable "cluster_name" {
  description = "Name of the kubernetes cluster"
}

variable "provider_url" {
  description = "oidc of the kubernetes cluster"
}

variable "version_prometheus_operator" {
  description = "Version of chart prometheus operator"
}

variable "region" {
  description = "AWS region"
}

variable "bucket_name" {
  description = "AWS s3 bucket name"
}
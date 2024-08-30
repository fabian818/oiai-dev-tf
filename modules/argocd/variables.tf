variable "domain" {
  description = "Domain for argo-cd"
}

variable "version_argo_cd" {
  description = "Argo cd version"
  default     = "6.10.0"
}

variable "certificate_arn" {
  description = "Domain certificate"
}

variable "role_arn" {

}
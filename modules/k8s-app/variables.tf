variable "app_name" {}
variable "namespace" {}
variable "image" {}
variable "replicas" {
  default = 1
}
variable "service_account" {}
variable "irsa_role_arn" {}
variable "command" {
  type    = list(string)
  default = null
}

variable "image_pull_policy" {
  type    = string
  default = "IfNotPresent"
}
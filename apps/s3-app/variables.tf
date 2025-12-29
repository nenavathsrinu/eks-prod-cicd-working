variable "region" {
  default = "ap-south-2"
}

variable "ecr_repo_url" {
  type = string
}

variable "image_tag" {
  type    = string
  default = ""
}
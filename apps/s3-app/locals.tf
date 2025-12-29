locals {
  image_tag = formatdate("YYYYMMDDHHmmss", timestamp())
  image_uri = "${var.ecr_repo_url}:${local.image_tag}"
}

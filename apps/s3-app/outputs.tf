output "image_uri" {
  value = "${var.ecr_repo_url}:${var.image_tag}"
}

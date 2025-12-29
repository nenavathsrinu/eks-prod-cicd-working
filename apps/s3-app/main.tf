data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "eks-prod-dev-tf-state"
    key    = "eks/terraform.tfstate"
    region = "ap-south-2"
    dynamodb_table = "eks-prod-dev-tf-lock"
    encrypt        = true
  }
}

module "s3_app" {
  source = "../../modules/k8s-app"

  app_name          = "s3-app"
  namespace         = "dev"
  service_account   = "s3-irsa-sa"
  image             = "${var.ecr_repo_url}:${local.image_tag}"
  replicas          = 1
  image_pull_policy = "IfNotPresent"
  command = [
    "python",
    "app.py"
  ]

  irsa_role_arn = data.terraform_remote_state.infra.outputs.irsa_role_arn

  depends_on = [
    null_resource.build_and_push
  ]
}


resource "null_resource" "build_and_push" {
  triggers = {
    image_tag = local.image_tag
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]

    command = <<EOT
      $env:AWS_PROFILE="project"
      $env:AWS_REGION="${var.region}"

      aws sts get-caller-identity

      aws ecr get-login-password --region ${var.region} |
        docker login --username AWS --password-stdin 442880721659.dkr.ecr.${var.region}.amazonaws.com

      docker build -t s3-irsa-app:${local.image_tag} .
      docker tag s3-irsa-app:${local.image_tag} ${local.image_uri}
      docker push ${local.image_uri}
    EOT
  }
}





terraform {
  backend "s3" {
    bucket         = "eks-prod-dev-tf-state"
    key            = "eks/terraform.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "eks-prod-dev-tf-lock"
    encrypt        = true
  }
}

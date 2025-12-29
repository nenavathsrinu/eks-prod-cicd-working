locals {
  common_tags = {
    project     = "eks_production"
    Environment = "prod"
    owner       = "devops_team"
    managed_by  = "terraform"
    Name        = "lsg_cluster"
  }
}
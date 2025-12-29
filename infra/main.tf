module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  cluster_name    = var.cluster_name
  tags            = local.common_tags
}

module "iam" {
  source       = "./modules/iam"
  cluster_name = var.cluster_name
  tags         = local.common_tags
  account_id   = var.account_id
}

module "eks" {
  source = "./modules/eks"

  cluster_name     = var.cluster_name
  cluster_role_arn = module.iam.cluster_role_arn
  subnet_ids       = module.vpc.private_subnet_ids

  tags = local.common_tags
}

module "nodegroup" {
  source = "./modules/nodegroup"

  cluster_name  = module.eks.cluster_name
  node_role_arn = module.iam.node_role_arn
  subnet_ids    = module.vpc.private_subnet_ids

  instance_types = var.instance_types
  desired_size   = var.desired_size
  min_size       = var.min_size
  max_size       = var.max_size
  disk_size      = var.disk_size
  capacity_type  = var.capacity_type

  tags = local.common_tags
}

module "irsa" {
  source               = "./modules/irsa"
  oidc_issuer          = module.eks.oidc_issuer
  namespace            = "dev"
  service_account_name = "s3-reader-sa"
  bucket_name          = "eks-prod-dev-tf-state"
  cluster_name         = module.eks.cluster_name

  depends_on = [module.eks]
}


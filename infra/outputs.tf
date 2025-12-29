output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca" {
  value = module.eks.cluster_ca
}

output "oidc_provider_arn" {
  value = module.irsa.oidc_provider_arn
}

output "irsa_role_arn" {
  value = module.irsa.role_arn
}

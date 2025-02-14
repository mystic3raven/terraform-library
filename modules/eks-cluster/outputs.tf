output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "kubeconfig" {
  value = module.eks.kubeconfig
}

output "oidc_provider_arn" {
  description = "The ARN of the EKS OIDC provider"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "The URL of the EKS OIDC provider"
  value       = module.eks.oidc_provider_url
}
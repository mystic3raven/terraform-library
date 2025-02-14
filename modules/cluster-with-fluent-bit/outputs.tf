output "fluent_bit_service_account_name" {
  description = "The name of the Fluent Bit service account"
  value       = kubernetes_service_account.fluent_bit.metadata[0].name
}

output "fluent_bit_daemonset_name" {
  description = "The name of the Fluent Bit DaemonSet"
  value       = kubernetes_daemonset.fluent_bit.metadata[0].name
}
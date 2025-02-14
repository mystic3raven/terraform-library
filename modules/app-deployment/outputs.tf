output "guestbook_url" {
  value = kubernetes_service.guestbook.status.0.load_balancer.0.ingress.0.hostname
}
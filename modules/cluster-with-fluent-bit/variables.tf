variable "aws_region" {
  description = "The AWS region where the EKS cluster is deployed"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The ARN of the EKS OIDC provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "The URL of the EKS OIDC provider"
  type        = string
}
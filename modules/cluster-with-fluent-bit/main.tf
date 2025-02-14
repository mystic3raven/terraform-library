provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Create a Kubernetes Namespace for Fluent Bit
resource "kubernetes_namespace" "fluent_bit" {
  metadata {
    name = "logging"
  }
}

# Create an IAM Role for Service Account (IRSA) for Fluent Bit
resource "aws_iam_role" "fluent_bit" {
  name = "eks-fluent-bit-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks_oidc.url, "https://", "")}:sub" = "system:serviceaccount:logging:fluent-bit"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fluent_bit_cloudwatch" {
  role       = aws_iam_role.fluent_bit.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Deploy Fluent Bit as a DaemonSet
resource "kubernetes_daemonset" "fluent_bit" {
  metadata {
    name      = "fluent-bit"
    namespace = kubernetes_namespace.fluent_bit.metadata[0].name
  }
  spec {
    selector {
      match_labels = {
        app = "fluent-bit"
      }
    }
    template {
      metadata {
        labels = {
          app = "fluent-bit"
        }
      }
      spec {
        service_account_name = "fluent-bit"
        container {
          name  = "fluent-bit"
          image = "amazon/aws-for-fluent-bit:latest"
          env {
            name  = "AWS_REGION"
            value = var.aws_region
          }
          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }
          volume_mount {
            name       = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          }
        }
        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
      }
    }
  }
}

# Create a Kubernetes ServiceAccount for Fluent Bit
resource "kubernetes_service_account" "fluent_bit" {
  metadata {
    name      = "fluent-bit"
    namespace = kubernetes_namespace.fluent_bit.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.fluent_bit.arn
    }
  }
}
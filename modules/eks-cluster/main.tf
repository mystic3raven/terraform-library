module "eks" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//patterns/basic?ref=v4.20.0"

  cluster_name       = var.cluster_name
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  public_subnet_ids  = var.public_subnet_ids

  enable_irsa         = true
  manage_aws_auth     = true
  kubernetes_version  = "1.27"
}
terraform {
  source = "../../../modules/cluster-with-fluent-bit"
}

dependency "eks-cluster" {
  config_path = "../eks-cluster"
}

inputs = {
  aws_region         = "us-west-2" # Replace with your AWS region
  oidc_provider_arn  = dependency.eks-cluster.outputs.oidc_provider_arn
  oidc_provider_url  = dependency.eks-cluster.outputs.oidc_provider_url
}
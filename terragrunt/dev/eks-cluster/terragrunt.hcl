terraform {
  source = "../../../modules/eks-cluster"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  cluster_name       = "dev-eks-cluster"
  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnets
  public_subnet_ids  = dependency.vpc.outputs.public_subnets
}
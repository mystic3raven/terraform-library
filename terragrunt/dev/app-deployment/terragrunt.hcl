terraform {
  source = "../../../modules/app-deployment"
}

dependency "eks-cluster" {
  config_path = "../eks-cluster"
}

inputs = {
  kubeconfig = dependency.eks-cluster.outputs.kubeconfig
}
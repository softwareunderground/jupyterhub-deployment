provider "aws" {
  # We use environment variables for authentication
}

data "aws_eks_cluster" "example" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "example" {
  name = local.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.example.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.example.token
  }
}

module "jupyterhub" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/jupyterhub-swung"

  jupyterhub_helm_chart_version = var.jupyterhub_helm_chart_version

  namespace    = var.environment

  home-pvc        = var.home-pvc
  conda-store-pvc = var.conda-store-pvc

  endpoint = var.endpoint

  jupyterhub-image  = var.jupyterhub-image
  jupyterlab-image  = var.jupyterlab-image
  dask-worker-image = var.dask-worker-image

  general-node-group = local.node_groups.general
  user-node-group    = local.node_groups.user
  worker-node-group  = local.node_groups.worker

  jupyterhub-overrides-values = [
    file("jupyterhub-values.yaml")
  ]

  dask-gateway-overrides-values = [
    file("dask-gateway-values.yaml")
  ]
}

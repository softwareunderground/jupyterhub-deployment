provider "kubernetes" {
  host                   = module.kubernetes.credentials.endpoint
  token                  = module.kubernetes.credentials.token
  cluster_ca_certificate = module.kubernetes.credentials.cluster_ca_certificate
}

module "kubernetes-initialization" {
  source = "/Users/filippo/Work/jupyterhub-terraform-modules/modules/kubernetes/initialization"

  namespace = var.environment
  secrets   = []
  dependencies = [

    module.kubernetes.depended_on

  ]
}

module "kubernetes-nfs-mount" {
  source = "/Users/filippo/Work/jupyterhub-terraform-modules/modules/kubernetes/nfs-mount"

  name         = "nfs-mount"
  namespace    = var.environment
  nfs_capacity = "10Gi"
  nfs_endpoint = module.efs.credentials.dns_name
  dependencies = [
    module.kubernetes-initialization.depended_on
  ]
}

module "kubernetes-conda-store-server" {
  source = "/Users/filippo/Work/jupyterhub-terraform-modules/modules/kubernetes/services/conda-store"

  name         = "conda-store"
  namespace    = var.environment
  nfs_capacity = "20Gi"
  environments = {

    "environment-default.yaml" = file("../conda-environments/environment-default.yaml")
    "environment-test-v1.yaml" = file("../conda-environments/environment-test-v1.yaml")

  }
  dependencies = [
    module.kubernetes-initialization.depended_on
  ]
}

module "kubernetes-conda-store-mount" {
  source = "/Users/filippo/Work/jupyterhub-terraform-modules/modules/kubernetes/nfs-mount"

  name         = "conda-store"
  namespace    = var.environment
  nfs_capacity = "20Gi"
  nfs_endpoint = module.kubernetes-conda-store-server.endpoint_ip
  dependencies = [
    module.kubernetes-initialization.depended_on
  ]
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = module.kubernetes.credentials.endpoint
    token                  = module.kubernetes.credentials.token
    cluster_ca_certificate = module.kubernetes.credentials.cluster_ca_certificate
  }
  version = "1.0.0"
}

module "kubernetes-autoscaling" {
  source = "/Users/filippo/Work/jupyterhub-terraform-modules/modules/kubernetes/services/cluster-autoscaler"

  namespace = var.environment

  aws-region   = var.region
  cluster-name = local.cluster_name

  dependencies = [
    module.kubernetes.depended_on
  ]
}

module "kubernetes-ingress" {
  source = "/Users/filippo/Work/jupyterhub-terraform-modules/modules/kubernetes/ingress"

  namespace = var.environment

  node-group = local.node_groups.general

  dependencies = [
    module.kubernetes-initialization.depended_on
  ]
}

provider "kubernetes" {
  host                   = module.kubernetes.credentials.endpoint
  token                  = module.kubernetes.credentials.token
  cluster_ca_certificate = module.kubernetes.credentials.cluster_ca_certificate
}

module "kubernetes-initialization" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/kubernetes/initialization"

  namespace = var.environment
  secrets   = []
  dependencies = [

    module.kubernetes.depended_on

  ]
}

module "kubernetes-nfs-mount" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/kubernetes/nfs-mount"

  name         = "nfs-mount"
  namespace    = var.environment
  nfs_capacity = "100Gi"
  nfs_endpoint = module.efs.credentials.dns_name
  dependencies = [
    module.kubernetes-initialization.depended_on
  ]
}

module "kubernetes-conda-store-server" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/kubernetes/services/conda-store"

  name              = "conda-store"
  namespace         = var.environment
  nfs_capacity      = "20Gi"
  node-group        = local.node_groups.general
  conda-store-image = var.conda-store-image
  environments      = {for env in var.conda_environments : env => file("../conda-environments/${env}")}
  dependencies = [
    module.kubernetes-initialization.depended_on
  ]
}

module "kubernetes-conda-store-mount" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/kubernetes/nfs-mount"

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
    host                   = module.kubernetes.credentials.endpoint
    token                  = module.kubernetes.credentials.token
    cluster_ca_certificate = module.kubernetes.credentials.cluster_ca_certificate
  }
}

module "kubernetes-autoscaling" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/kubernetes/services/cluster-autoscaler"

  namespace = var.environment

  aws-region   = var.region
  cluster-name = local.cluster_name

  dependencies = [
    module.kubernetes.depended_on
  ]
}

module "kubernetes-ingress" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/kubernetes/ingress"

  namespace = var.environment

  node-group = local.node_groups.general

  dependencies = [
    module.kubernetes-initialization.depended_on
  ]
}

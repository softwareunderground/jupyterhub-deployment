variable "project_name" {
  description = "Name for the JupyterHub deployment"
  type    = string
}

variable "environment" {
  description = "JupyterHub environment, such as dev, prod, ..."
  type        = string
}

variable "jupyterhub_helm_chart_version" {
  description = "JupyterHub Helm chart version"
  type        = string
  default     = "0.11.1"
}

variable "endpoint" {
  description = "Jupyterhub endpoint"
  type        = string
}

variable "home-pvc" {
  description = "PVC for home directories"
  type        = string
}

variable "conda-store-pvc" {
  description = "PVC for conda store"
  type        = string
}

variable "jupyterhub-image" {
  description = "JupyterHub image"
  type = object({
    name = string
    tag  = string
  })
}

variable "jupyterlab-image" {
  description = "Jupyter lab user image"
  type = object({
    name = string
    tag  = string
  })
}

variable "dask-worker-image" {
  description = "Dask worker image"
  type = object({
    name = string
    tag  = string
  })
}

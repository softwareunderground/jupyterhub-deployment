output "ingress_jupyter" {
  description = "jupyter.<domain> ingress endpoint"
  value       = module.kubernetes-ingress.endpoint
}

output "home-pvc" {
  description = "PVC for home directories"
  value       = module.kubernetes-nfs-mount.persistent_volume_claim.name
}

output "conda-store-pvc" {
  description = "PVC for conda store"
  value       = module.kubernetes-conda-store-mount.persistent_volume_claim.name
}

output "jupyterhub_values" {
  description = "Final version of the values passed to the Helm chart"
  value       = module.jupyterhub.jupyterhub_values
}

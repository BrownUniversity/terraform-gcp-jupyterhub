output "project_name" {
  description = "Project Name"
  value       = module.jhub_project.project_name
}

output "project_id" {
  description = "Project ID"
  value       = module.jhub_project.project_id
}

# ---------------------------------------------------------------
#  GKE Outputs
# ---------------------------------------------------------------

output "region" {
  value = module.jhub_cluster.region
}

output "cluster_name" {
  description = "Cluster name"
  value       = var.cluster_name
}

output "location" {
  value = module.jhub_cluster.location
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.jhub_cluster.zones
}


output "project_name" {
  description = "Project Name"
  value       = module.jhub_project.project_name
}

output "project_id" {
  description = "Project ID"
  value       = module.jhub_project.project_id
}

output "hub_ip" {
  description = "Static IP assigned to the Jupyter Hub"
  value       = google_compute_address.static.address
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

# ---------------------------------------------------------------
#  Logging Outputs
# ---------------------------------------------------------------

output "sumologic_source_name" {
  description = "Name of the source created in sumologic for the hub"
  value       = module.gcp-log-export.sumologic_source_name
}

output "sumologic_endpoint" {
  description = "URL used by the GCP log sink to push logs to"
  value       = module.gcp-log-export.sumologic_endpoint
}





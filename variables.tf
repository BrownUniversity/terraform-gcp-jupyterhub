# ---------------------------------------------------------------
#  PROJECT VARIABLES
# ---------------------------------------------------------------
variable org_id {
  description = "Organization id."
}

variable billing_account {
  description = "Billing account id."
}

variable project_name {
  description = "Name of the project."
}

variable random_project_id {
  description = "Enable random number to the end of the project."
  default     = true
}

variable auto_create_network {
  description = "Auto create default network."
  default     = false
}

variable activate_apis {
  description = "The list of apis to activate within the project	"
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com"
  ]
}

variable folder_id {
  description = "The ID of a folder to host this project"
}

variable default_service_account {
  description = "Project default service account setting: can be one of delete, depriviledge, or keep."
  default     = "delete"
}
variable disable_dependent_services {
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed."
  default     = "true"
}

variable labels {
  description = "Map of labels for project."
  default = {
    "environment" = "automation"
    "managed_by"  = "terraform"
  }
}

# ---------------------------------------------------------------
#  VPC VARIABLES
# ---------------------------------------------------------------

variable network_name {
  description = "Name of the VPC."
  default     = "kubernetes-vpc"
}

variable routing_mode {
  description = "Routing mode. GLOBAL or REGIONAL"
  default     = "GLOBAL"
}

variable subnet_name {
  description = "Name of the subnet."
  default     = "kubernetes-subnet"
}

variable subnet_ip {
  description = "Subnet IP CIDR."
  default     = "10.0.0.0/17"
}

variable subnet_private_access {
  default = "true"
}

variable subnet_flow_logs {
  default = "true"
}

variable description {
  default = "Deployed through Terraform."
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  default     = "192.168.0.0/18"
}

variable "ip_range_services" {
  description = "The secondary ip range to use for pods"
  default     = "192.168.64.0/18"
}

variable range_name_pods {
  description = "The range name for pods"
  default     = "kubernetes-pods"
}

variable range_name_services {
  description = "The range name for services"
  default     = "kubernetes-services"
}

# ---------------------------------------------------------------
#  GKE VARIABLES
# ---------------------------------------------------------------

variable "cluster_name" {
  description = "Cluster name"
  default     = "default"
}

variable "regional" {
  default = true
}

variable "region" {
  description = "The region to host the cluster in"
}

variable "gcp_zone" {
  type        = string
  description = "The GCP zone to deploy the runner into."
}

variable "network" {
  description = "The VPC network to host the cluster in"
  default     = "kubernetes-vpc"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  default     = "kubernetes-subnet"
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  default     = "logging.googleapis.com/kubernetes"
}

variable "maintenance_start_time" {
  description = "Time window specified for daily maintenance operations in RFC3339 format"
  default     = "03:00"
}

variable "create_service_account" {
  default = "false"
}

variable "skip_provisioners" {
  type        = bool
  description = "Flag to skip local-exec provisioners"
  default     = false
}

variable "http_load_balancing" {
  default = false
}

variable "horizontal_pod_autoscaling" {
  default = true
}

variable "network_policy" {
  default = true
}

variable "enable_private_nodes" {
  default = false
}

variable "master_ipv4_cidr_block" {
  default = "172.16.0.0/28"
}

variable "remove_default_node_pool" {
  default = false
}

# ----------------------------------------
#  NODE POOL VALUES
# ----------------------------------------

variable "core_pool_name" {
  default = "core-pool"
}

variable "core_pool_machine_type" {
  default = "n1-highmem-4"
}

variable "core_pool_min_count" {
  default = 1
}

variable "core_pool_max_count" {
  default = 3
}

variable "core_pool_local_ssd_count" {
  default = 0
}

variable "core_pool_disk_size_gb" {
  default = 100
}

variable "core_pool_disk_type" {
  default = "pd-standard"
}

variable "core_pool_image_type" {
  default = "COS"
}

variable "core_pool_auto_repair" {
  default = true
}

variable "core_pool_auto_upgrade" {
  default = true
}

variable "core_pool_preemptible" {
  default = false
}

variable "core_pool_initial_node_count" {
  default = 1
}

variable "core_pool_oauth_scope" {
  default = "https://www.googleapis.com/auth/cloud-platform"
}

# ----------------------------------------
#  USER POOL VALUES
# ----------------------------------------

variable "user_pool_name" {
  default = "user-pool"
}

variable "user_pool_machine_type" {
  default = "n1-highmem-8"
}

variable "user_pool_min_count" {
  default = 1
}

variable "user_pool_max_count" {
  default = 3
}

variable "user_pool_local_ssd_count" {
  default = 0
}

variable "user_pool_disk_size_gb" {
  default = 100
}

variable "user_pool_disk_type" {
  default = "pd-standard"
}

variable "user_pool_image_type" {
  default = "COS"
}

variable "user_pool_auto_repair" {
  default = true
}

variable "user_pool_auto_upgrade" {
  default = true
}

variable "user_pool_preemptible" {
  default = false
}

variable "user_pool_initial_node_count" {
  default = 1
}

variable "user_pool_oauth_scope" {
  default = "https://www.googleapis.com/auth/cloud-platform"
}

# ---------------------------------------------------------------
#  HELM VARIABLES
# ---------------------------------------------------------------

variable "automount_service_account_token" {
  default = true
}

variable "helm_repository_url" {
  default = "https://jupyterhub.github.io/helm-chart/"
}

variable "helm_values_file" {
  description = "Relative path and file name. Example: values.yaml"
}
variable "helm_secrets_file" {
  description = "Relative path and file name. Example: secrets.yaml"
}

variable "jhub_helm_version" {
  description = "Version of the JupyterHub Helm Chart Release"
}

variable "helm_deploy_timeout" {
  description = "Time for helm to wait for deployment of chart and downloading of docker image"
  default     = 1000
}

# INFOBLOX
variable "infoblox_username" {

}

variable "infoblox_password" {

}

variable "infoblox_host" {

}

variable "record_hostname" {

}

variable "record_domain" {

}

# --------------------------------------
#   Cron Jobs
# --------------------------------------

variable scale_down_name {
  default = "scale-down"
}

variable scale_down_schedule {
  default = "1 18 * * 1-5"
}

variable scale_down_command {
  default = ["kubectl", "scale", "--replicas=0", "statefulset/user-placeholder"]
}

variable scale_up_name {
  default = "scale-up"
}

variable scale_up_schedule {
  default = "1 6 * * 1-5"
}

variable scale_up_command {
  default = ["kubectl", "scale", "--replicas=3", "statefulset/user-placeholder"]
}

# ---------------------------------------------------------------
#  PROJECT VARIABLES
# ---------------------------------------------------------------
variable "org_id" {
  type        = number
  description = "Organization id."
}

variable "billing_account" {
  type        = string
  description = "Billing account id."
}

variable "project_name" {
  type        = string
  description = "Name of the project."
}

variable "random_project_id" {
  type        = bool
  description = "Enable random number to the end of the project."
  default     = true
}

variable "auto_create_network" {
  type        = bool
  description = "Auto create default network."
  default     = false
}

variable "activate_apis" {
  type        = list(string)
  description = "The list of apis to activate within the project	"
  default     = []
}

variable "folder_id" {
  description = "The ID of a folder to host this project"
}

variable "default_service_account" {
  type        = string
  description = "Project default service account setting: can be one of delete, depriviledge, or keep."
  default     = "delete"
}
variable "disable_dependent_services" {
  type        = string
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed."
  default     = "true"
}

variable "labels" {
  type        = map(string)
  description = "Map of labels for project."
  default = {
    "environment" = "automation"
    "managed_by"  = "terraform"
  }
}

# ---------------------------------------------------------------
#  VPC VARIABLES
# ---------------------------------------------------------------

variable "network_name" {
  type        = string
  description = "Name of the VPC."
  default     = "kubernetes-vpc"
}

variable "routing_mode" {
  type        = string
  description = "Routing mode. GLOBAL or REGIONAL"
  default     = "GLOBAL"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet."
  default     = "kubernetes-subnet"
}

variable "subnet_ip" {
  type        = string
  description = "Subnet IP CIDR."
  default     = "10.0.0.0/17"
}

variable "subnet_private_access" {
  type        = string
  description = "Whether this subnet will have private Google access enabled"
  default     = "true"
}

variable "subnet_flow_logs" {
  type        = string
  description = "Whether the subnet will record and send flow log data to logging"
  default     = "true"
}

variable "description" {
  type        = string
  description = "VPC description"
  default     = "Deployed through Terraform."
}

variable "ip_range_pods" {
  type        = string
  description = "The secondary ip range to use for pods"
  default     = "192.168.0.0/18"
}

variable "ip_range_services" {
  type        = string
  description = "The secondary ip range to use for pods"
  default     = "192.168.64.0/18"
}

variable "range_name_pods" {
  type        = string
  description = "The range name for pods"
  default     = "kubernetes-pods"
}

variable "range_name_services" {
  type        = string
  description = "The range name for services"
  default     = "kubernetes-services"
}

# --------------------------------------
#   Infoblox
# --------------------------------------
variable "dns_manager" {
  description = "Service used to manage your DNS"
  type        = string
  default     = "infoblox"
}


variable "record_domain" {
  description = "The domain on the record. hostaname.domain = FQDN"
  type        = string
}

variable "record_hostname" {
  description = "The domain on the record. hostaname.domain = FQDN"
  type        = string
}

# ---------------------------------------------------------------
#  GKE VARIABLES
# ---------------------------------------------------------------

variable "cluster_name" {
  type        = string
  description = "Cluster name"
  default     = "default"
}

variable "regional" {
  type        = bool
  description = "Whether the master node should be regional or zonal"
  default     = true
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-east1"
}

variable "gcp_zone" {
  type        = string
  description = "The GCP zone to deploy the runner into."
  default     = "us-east1-b"
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
  type        = bool
  description = "Defines if service account specified to run nodes should be created."
  default     = false
}

variable "skip_provisioners" {
  type        = bool
  description = "Flag to skip local-exec provisioners"
  default     = false
}

variable "http_load_balancing" {
  type        = bool
  description = "Enable httpload balancer addon"
  default     = false
}

variable "horizontal_pod_autoscaling" {
  type        = bool
  description = "Enable horizontal pod autoscaling addon"
  default     = true
}

variable "network_policy" {
  type        = bool
  description = "Enable network policy addon"
  default     = true
}

variable "enable_private_nodes" {
  type        = bool
  description = "(Beta) Whether nodes have internal IP addresses only"
  default     = false
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "(Beta) The IP range in CIDR notation to use for the hosted master network"
  default     = "172.16.0.0/28"
}

variable "remove_default_node_pool" {
  type        = bool
  description = "Remove default node pool while setting up the cluster"
  default     = false
}

# ----------------------------------------
#  NODE POOL VALUES
# ----------------------------------------

variable "core_pool_name" {
  type        = string
  description = "Name for the core-component pool"
  default     = "core-pool"
}

variable "core_pool_machine_type" {
  type        = string
  description = "Machine type for the core-component pool"
  default     = "n1-highmem-4"
}

variable "core_pool_min_count" {
  type        = number
  description = "Minimum number of nodes in the core-component pool"
  default     = 1
}

variable "core_pool_max_count" {
  type        = number
  description = "Maximum number of nodes in the core-component pool"
  default     = 3
}

variable "core_pool_local_ssd_count" {
  type        = number
  description = "Number of SSDs core-component pool"
  default     = 0
}

variable "core_pool_disk_size_gb" {
  type        = number
  description = "Size of disk for core-component pool"
  default     = 100
}

variable "core_pool_disk_type" {
  type        = string
  description = "Type of disk core-component pool"
  default     = "pd-standard"
}

variable "core_pool_image_type" {
  type        = string
  description = "Type of image core-component pool"
  default     = "COS"
}

variable "core_pool_auto_repair" {
  type        = bool
  description = "Enable auto-repair of core-component pool"
  default     = true
}

variable "core_pool_auto_upgrade" {
  type        = bool
  description = "Enable auto-upgrade of core-component pool"
  default     = true
}

variable "core_pool_preemptible" {
  type        = bool
  description = "Make core-component pool preemptible"
  default     = false
}

variable "core_pool_initial_node_count" {
  type        = number
  description = "Number of initial nodes in core-component pool"
  default     = 1
}

variable "core_pool_oauth_scope" {
  type        = string
  description = "OAuth scope for core-component pool"
  default     = "https://www.googleapis.com/auth/cloud-platform"
}

# ----------------------------------------
#  USER POOL VALUES
# ----------------------------------------

variable "user_pool_name" {
  type        = string
  description = "Name for the user pool"
  default     = "user-pool"
}

variable "user_pool_machine_type" {
  type        = string
  description = "Machine type for the user pool"
  default     = "n1-highmem-4"
}

variable "user_pool_min_count" {
  type        = number
  description = "Minimum number of nodes in the user pool"
  default     = 1
}

variable "user_pool_max_count" {
  type        = number
  description = "Maximum number of nodes in the user pool"
  default     = 20
}

variable "user_pool_local_ssd_count" {
  type        = number
  description = "Number of SSDs user pool"
  default     = 0
}

variable "user_pool_disk_size_gb" {
  type        = number
  description = "Size of disk for user pool"
  default     = 100
}

variable "user_pool_disk_type" {
  type        = string
  description = "Type of disk user pool"
  default     = "pd-standard"
}

variable "user_pool_image_type" {
  type        = string
  description = "Type of image user pool"
  default     = "COS"
}

variable "user_pool_auto_repair" {
  type        = bool
  description = "Enable auto-repair of user pool"
  default     = true
}

variable "user_pool_auto_upgrade" {
  type        = bool
  description = "Enable auto-upgrade of user pool"
  default     = true
}

variable "user_pool_preemptible" {
  type        = bool
  description = "Make user pool preemptible"
  default     = false
}

variable "user_pool_initial_node_count" {
  type        = number
  description = "Number of initial nodes in user pool"
  default     = 1
}

variable "user_pool_oauth_scope" {
  type        = string
  description = "OAuth scope for user pool"
  default     = "https://www.googleapis.com/auth/cloud-platform"
}


# ---------------------------------------------------------------
#  SHARE NFS VARIABLES
# ---------------------------------------------------------------
variable "use_shared_volume" {
  type        = bool
  description = "Whether to use a shared NFS volume"
  default     = false
}

variable "shared_storage_capacity" {
  type        = number
  description = "Size of the shared volume"
  default     = 5
}

# ---------------------------------------------------------------
#  TLS VARIABLES
# ---------------------------------------------------------------
variable "create_tls_secret" {
  description = "If set to true, user will be passing tls key and certificate to create a kubernetes secret, and use it in their helm chart"
  type        = bool
  default     = true
}

variable "tls_secret_name" {
  description = "TLS secret name used in secret creation, it must match with what is used by user in helm chart"
  type        = string
  default     = "jupyterhub-tls"
}

variable "site_certificate" {
  type        = string
  description = "File containing the TLS certificate"
}

variable "site_certificate_key" {
  type        = string
  description = "File containing the TLS certificate key"
}

# ---------------------------------------------------------------
#  HELM VARIABLES
# ---------------------------------------------------------------

variable "automount_service_account_token" {
  type        = bool
  description = "Enable automatin mounting of the service account token"
  default     = true
}

variable "helm_repository_url" {
  type        = string
  description = "URL for JupyterHub's Helm chart"
  default     = "https://jupyterhub.github.io/helm-chart/"
}

variable "helm_values_file" {
  type        = string
  description = "Relative path and file name. Example: values.yaml"
}

variable "jhub_helm_version" {
  type        = string
  description = "Version of the JupyterHub Helm Chart Release"
}

variable "helm_deploy_timeout" {
  type        = number
  description = "Time for helm to wait for deployment of chart and downloading of docker image"
  default     = 1000
}

variable "auth_type" {
  type        = string
  description = "Type OAuth e.g google"
  default     = "dummy"
}

variable "auth_secretkeyvaluemap" {
  type        = map(string)
  description = "Key Value Map for secret variables used by the authenticator"
  default = {
    "auth.dummy.password"  = "dummy_password"
    "auth.dummy2.password" = "dummy_password"
  }
}

# --------------------------------------
#   Cron Jobs
# --------------------------------------

variable "scale_down_name" {
  type        = string
  description = "Name of scale-down cron job"
  default     = "scale-down"
}

variable "scale_up_name" {
  type        = string
  description = "Name of scale-up cron job"
  default     = "scale-up"
}

variable "scale_down_schedule" {
  type        = string
  description = "Schedule for scale-down cron job"
  default     = "1 18 * * 1-5"
}

variable "scale_down_command" {
  type        = list(string)
  description = "Command for scale-down cron job"
  default     = ["kubectl", "scale", "--replicas=0", "statefulset/user-placeholder"]
}

variable "scale_up_schedule" {
  type        = string
  description = "Schedule for scale-up cron job"
  default     = "1 6 * * 1-5"
}

variable "scale_up_command" {
  type        = list(string)
  description = "Command for scale-up cron job"
  default     = ["kubectl", "scale", "--replicas=3", "statefulset/user-placeholder"]
}

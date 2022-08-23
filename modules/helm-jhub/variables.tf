variable "cluster_ca_certificate" {
  sensitive   = true
  description = "The cluster_ca_certificate value for use with the kubernetes provider."
}

variable "host" {
  description = "The host value for use with the kubernetes provider."
}

variable "token" {
  sensitive   = true
  description = "The token value for use with the kubernetes provider."
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
variable "static_ip" {
  type        = string
  description = "static ip of load-balancer"
}

variable "automount_service_account_token" {
  type        = bool
  description = "Automount service account token for CronJobs"
  default     = true
}

variable "helm_values_file" {
  type        = string
  description = "YAML file containing JupyterHub HELM values. Relative path and file name. Example: config.yaml"
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

variable "jhub_namespace" {
  type        = string
  description = "Name of JupyterHub's kubernetes namespace"
  default     = "jhub"
}

variable "jhub_url" {
  type        = string
  description = "URL for the jupyter hub"
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
    "auth.dummy.password" = "dummy_password"
  }
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

variable "project_id" {
  type        = string
  description = "GCP Project ID"
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

# ---------------------------------------------------------------
#  HELM VARIABLES
# ---------------------------------------------------------------
variable "kubernetes_context" {
  type        = string
  description = "Context of current kubernetes cluster"
}

variable "static_ip" {
  type        = string
  description = "static ip of load-balancer"
}

variable "automount_service_account_token" {
  type        = bool
  description = "Automount service account token for CronJobs"
  default     = true
}

variable "helm_repository_name" {
  type        = string
  description = "Name of Jupyterhub's Helm repository"
  default     = "jupyterhub"
}

variable "helm_repository_url" {
  type        = string
  description = "URL of Jupyterhub's Helm repository"
  default     = "https://jupyterhub.github.io/helm-chart/"
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

# --------------------------------------
#   Cron Jobs
# --------------------------------------

variable scale_down_name {
  type        = string
  description = "Name of scale-down cron job"
  default     = "scale-down"
}

variable scale_up_name {
  type        = string
  description = "Name of scale-up cron job"
  default     = "scale-up"
}

variable scale_down_schedule {
  type        = string
  description = "Schedule for scale-down cron job"
  default     = "1 18 * * 1-5"
}

variable scale_down_command {
  type        = list(string)
  description = "Command for scale-down cron job"
  default     = ["kubectl", "scale", "--replicas=0", "statefulset/user-placeholder"]
}

variable scale_up_schedule {
  type        = string
  description = "Schedule for scale-up cron job"
  default     = "1 6 * * 1-5"
}

variable scale_up_command {
  type        = list(string)
  description = "Command for scale-up cron job"
  default     = ["kubectl", "scale", "--replicas=3", "statefulset/user-placeholder"]
}

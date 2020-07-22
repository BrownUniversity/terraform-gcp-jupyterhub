# ---------------------------------------------------------------
#  HELM VARIABLES
# ---------------------------------------------------------------
variable "kubernetes_context" {
  description = "Context of current kubernetes cluster"
}

variable "static_ip" {
  description = "static ip of load-balancer" 
}

variable "automount_service_account_token" {
  default = true
}

variable "helm_repository_name" {
  default = "jupyterhub"
}

variable "helm_repository_url" {
  default = "https://jupyterhub.github.io/helm-chart/"
}

variable "helm_values_file" {
  description = "Relative path and file name. Example: config.yaml"
}

variable "helm_secrets_file" {
  description = "Relative path and file name. Example: config.yaml"
}

variable "jhub_helm_version" {
  description = "Version of the JupyterHub Helm Chart Release"
}

variable "helm_deploy_timeout" {
  description = "Time for helm to wait for deployment of chart and downloading of docker image"
  default = 1000
}

variable "jhub_namespace" {
  default = "jhub"
}

variable "jhub_url" {
  description = "URL for the jupyter hub"
}

# --------------------------------------
#   Cron Jobs
# --------------------------------------

variable scale_down_name {
   default = "scale-down"
}

variable scale_up_name {
   default = "scale-up"
}

variable scale_down_schedule {
  default = "1 18 * * 1-5"
}

variable scale_down_command {
  default = ["kubectl", "scale", "--replicas=0", "statefulset/user-placeholder"]
}

variable scale_up_schedule {
  default = "1 6 * * 1-5"
}

variable scale_up_command {
  default = ["kubectl", "scale", "--replicas=3", "statefulset/user-placeholder"]
} 	
# variable "kubernetes_context" {
#   type        = string
#   description = "Context of current kubernetes cluster"
# }

variable "use_shared_volume" {
  type        = bool
  description = "Whether to use a shared NFS volume"
  default     = false
}

variable "shared_storage_capacity" {
  type        = string
  description = "Size of the shared volume"
  default     = "10Gi"
}

variable "jhub_namespace" {
  type        = string
  description = "Name of JupyterHub's kubernetes namespace"
  default     = "jhub"
}
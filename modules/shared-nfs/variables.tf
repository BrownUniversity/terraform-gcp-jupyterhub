variable "use_share_volume" {
  type        = bool
  description = "Whether to use a shared NFS volume"
  default     = false
}

variable "shared_storage_capacity" {
  type        = string
  description = "Size of the shared volume"
  default     = "10Gi"
}
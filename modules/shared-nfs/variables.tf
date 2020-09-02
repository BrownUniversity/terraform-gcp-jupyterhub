variable "use_shared_volume" {
  type        = bool
  description = "Whether to use a shared NFS volume"
  default     = false
}

variable "name" {
  type        = string
  description = "Name of the NFS module/object"
  default     = "gke-nfs"
}

variable "volumes" {
  type        = map(number)
  description = "Map of volume_name = GB of storage"
  default     = {}
}

variable "zone" {
  type        = string
  description = "The GCP zone where the persistent disk will live."
  default     = "us-east1-b"
}

variable "namespace" {
  type        = string
  description = "Name of kubernetes namespace to create the related resources"
  default     = "jhub"
}

variable "annotations" {
  type        = map
  description = "Annotations for NFS Server"
  default     = {}
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}
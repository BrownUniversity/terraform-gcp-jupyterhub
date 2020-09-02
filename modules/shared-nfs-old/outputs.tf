output "name" {
  description = "Name of NFS persistent_volume name for shared data location in notebooks"
  value       = var.use_shared_volume ? kubernetes_persistent_volume.nfs-volume[0].metadata.0.name : ""
}
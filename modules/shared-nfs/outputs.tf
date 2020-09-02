output "name" {
  description = "Name of NFS persistent_volume name for shared data location in notebooks"
  value       = "${kubernetes_persistent_volume.nfs-volume.metadata.0.name}"
}
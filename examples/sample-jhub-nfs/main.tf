resource "random_integer" "tenant_id" {
  min = 1
  max = 50000
}


locals {
  gcp_region  = "us-east1"
  gcp_zone    = "us-east1-b"
  jhub_tenant = "sample-${random_integer.tenant_id.result}"
  jhub_domain = "jupyter.brown.edu"
}

# tfsec:ignore:google-compute-disk-encryption-customer-key
module "sample-jhub" {
  source = "../../"

  # ---------------- PROJECT VARIABLES -----------------------
  project_name = "jhub-${local.jhub_tenant}"

  # The following variables need to be included in secrets.auto.tfvars
  org_id          = var.org_id
  billing_account = var.billing_account
  folder_id       = var.folder_id

  # ---------------- INFOBLOX VARIABLES -----------------------
  record_hostname = local.jhub_tenant
  record_domain   = local.jhub_domain

  # ---------------- CLUSTER VARIABLES -----------------------
  kubernetes_version         = 1.27
  regional                   = false
  region                     = local.gcp_region
  gcp_zone                   = local.gcp_zone
  maintenance_start_time     = "03:00"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true

  core_pool_machine_type       = "n1-standard-4"
  core_pool_min_count          = 1
  core_pool_max_count          = 2
  core_pool_local_ssd_count    = 0
  core_pool_disk_size_gb       = 100
  core_pool_auto_repair        = true
  core_pool_auto_upgrade       = true
  core_pool_preemptible        = false
  core_pool_initial_node_count = 1

  user_pool_machine_type       = "n1-standard-4"
  user_pool_min_count          = 0
  user_pool_max_count          = 2
  user_pool_local_ssd_count    = 0
  user_pool_disk_size_gb       = 100
  user_pool_auto_repair        = true
  user_pool_auto_upgrade       = true
  user_pool_preemptible        = false
  user_pool_initial_node_count = 1

  # ---------------- TLS -----------------------
  create_tls_secret    = true
  site_certificate     = file(var.site_certificate_file)
  site_certificate_key = file(var.site_certificate_key_file)

  # ---------------- NFS -----------------------
  use_shared_volume       = true
  shared_storage_capacity = 2

  # ---------------- HELM/JHUB VARIABLES -----------------------
  jhub_helm_version   = "3.0.0-beta.3.git.6259.h5b6e57ed"
  helm_deploy_timeout = 2000
  helm_values_file    = "./values.yaml"

  # ---------------- CRONJOB VARIABLES -----------------------
  scale_up_schedule   = "30 19 * * 4"
  scale_up_command    = ["kubectl", "scale", "--replicas=0", "statefulset/user-placeholder"]
  scale_down_schedule = "50 23 * * 4"
  scale_down_command  = ["kubectl", "scale", "--replicas=0", "statefulset/user-placeholder"]

}

locals {
  default_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com"
  ]
}


# ------------------------------------------------------------
#   PROJECT
# ------------------------------------------------------------
module "jhub_project" {
  source = "git::https://github.com/BrownUniversity/terraform-gcp-project.git?ref=v0.1.8"

  project_name               = var.project_name
  org_id                     = var.org_id
  billing_account            = var.billing_account
  folder_id                  = var.folder_id
  auto_create_network        = var.auto_create_network
  activate_apis              = concat(local.default_apis, var.activate_apis)
  default_service_account    = var.default_service_account
  disable_dependent_services = var.disable_dependent_services
  labels                     = var.labels
}

# ------------------------------------------------------------
#   VPC
# ------------------------------------------------------------
module "jhub_vpc" {
  source = "git::https://github.com/BrownUniversity/terraform-gcp-vpc.git?ref=v0.1.6"

  project_id          = module.jhub_project.project_id
  network_name        = var.network_name
  subnet_name         = var.subnet_name
  subnet_region       = var.region
  range_name_pods     = var.range_name_pods
  range_name_services = var.range_name_services
}

# ------------------------------------------------------------
#   DNS
# ------------------------------------------------------------
# Reserve a static IP address
resource "google_compute_address" "static" {
  name    = "loadbalancer"
  project = module.jhub_project.project_id
  region  = var.region
}

# Assign Brown-DNS via infoblox
module "production_infoblox_record" {
  source          = "git::https://github.com/BrownUniversity/terraform-infoblox-record-a.git?ref=v0.1.7"
  record_ip       = google_compute_address.static.address
  record_hostname = var.record_hostname
  record_domain   = var.record_domain
  record_dns_view = "production"
}

module "external_infoblox_record" {
  source          = "git::https://github.com/BrownUniversity/terraform-infoblox-record-a.git?ref=v0.1.7"
  record_ip       = google_compute_address.static.address
  record_hostname = var.record_hostname
  record_domain   = var.record_domain
  record_dns_view = "external"
}


# Create the cluster
# tfsec:ignore:google-gke-enforce-pod-security-policy 
# tfsec:ignore:google-gke-enable-master-networks
# tfsec:ignore:google-gke-use-cluster-labels
# tfsec:ignore:google-gke-enable-private-cluster
module "jhub_cluster" {
  source                     = "git::https://github.com/BrownUniversity/terraform-gcp-cluster.git?ref=v0.1.12"
  cluster_name               = var.cluster_name
  project_id                 = module.jhub_project.project_id
  kubernetes_version         = var.kubernetes_version
  regional                   = var.regional
  region                     = var.region
  node_zones                 = [var.gcp_zone]
  network                    = module.jhub_vpc.network_name
  subnetwork                 = module.jhub_vpc.subnet_name
  logging_service            = var.logging_service
  monitoring_service         = var.monitoring_service
  maintenance_start_time     = var.maintenance_start_time
  create_service_account     = var.create_service_account
  service_account_email      = module.jhub_project.service_account_email
  http_load_balancing        = var.http_load_balancing
  horizontal_pod_autoscaling = var.horizontal_pod_autoscaling
  network_policy             = var.network_policy
  enable_private_nodes       = var.enable_private_nodes
  remove_default_node_pool   = var.remove_default_node_pool

  core_pool_name               = var.core_pool_name
  core_pool_machine_type       = var.core_pool_machine_type
  core_pool_min_count          = var.core_pool_min_count
  core_pool_max_count          = var.core_pool_max_count
  core_pool_local_ssd_count    = var.core_pool_local_ssd_count
  core_pool_disk_size_gb       = var.core_pool_disk_size_gb
  core_pool_disk_type          = var.core_pool_disk_type
  core_pool_image_type         = var.core_pool_image_type
  core_pool_auto_repair        = var.core_pool_auto_repair
  core_pool_auto_upgrade       = var.core_pool_auto_upgrade
  core_pool_preemptible        = var.core_pool_preemptible
  core_pool_initial_node_count = var.core_pool_initial_node_count

  user_pool_name               = var.user_pool_name
  user_pool_machine_type       = var.user_pool_machine_type
  user_pool_min_count          = var.user_pool_min_count
  user_pool_max_count          = var.user_pool_max_count
  user_pool_local_ssd_count    = var.user_pool_local_ssd_count
  user_pool_disk_size_gb       = var.user_pool_disk_size_gb
  user_pool_disk_type          = var.user_pool_disk_type
  user_pool_image_type         = var.user_pool_image_type
  user_pool_auto_repair        = var.user_pool_auto_repair
  user_pool_auto_upgrade       = var.user_pool_auto_upgrade
  user_pool_preemptible        = var.user_pool_preemptible
  user_pool_initial_node_count = var.user_pool_initial_node_count

}

# ------------------------------------------------------------
#  CONNECT KUBECTL
# ------------------------------------------------------------

locals {
  gcloud_location = var.regional ? var.region : var.gcp_zone
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  # THIS SHOULD NOT BE UPGRADED PAST 34.0.0 UNLESS ABSOLUTELY NECESSARY
  version      = "37.0.0"
  depends_on   = [module.jhub_cluster]
  project_id   = module.jhub_project.project_id
  location     = local.gcloud_location
  cluster_name = var.cluster_name
}

# ------------------------------------------------------------
#  HELM
# ------------------------------------------------------------
module "jhub_helm" {
  source = "./modules/helm-jhub"

  cluster_ca_certificate          = module.gke_auth.cluster_ca_certificate
  host                            = module.gke_auth.host
  token                           = module.gke_auth.token
  automount_service_account_token = var.automount_service_account_token
  helm_values_file                = var.helm_values_file
  jhub_helm_version               = var.jhub_helm_version
  jhub_url                        = "${var.record_hostname}.${var.record_domain}"
  helm_deploy_timeout             = var.helm_deploy_timeout
  static_ip                       = google_compute_address.static.address
  scale_down_name                 = var.scale_down_name
  scale_down_schedule             = var.scale_down_schedule
  scale_down_command              = var.scale_down_command
  scale_up_name                   = var.scale_up_name
  scale_up_schedule               = var.scale_up_schedule
  scale_up_command                = var.scale_up_command
  create_tls_secret               = var.create_tls_secret
  tls_secret_name                 = var.tls_secret_name
  site_certificate                = var.site_certificate
  site_certificate_key            = var.site_certificate_key
  auth_type                       = var.auth_type
  auth_secretkeyvaluemap          = var.auth_secretkeyvaluemap

  #shared volume 
  use_shared_volume       = var.use_shared_volume
  shared_storage_capacity = var.shared_storage_capacity
  gcp_zone                = var.gcp_zone
  project_id              = module.jhub_project.project_id
}

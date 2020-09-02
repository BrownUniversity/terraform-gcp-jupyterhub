# ------------------------------------------------------------
#   PROVIDER BLOCK
# ------------------------------------------------------------
provider "kubernetes" {
  config_context = var.kubernetes_context
}

provider "helm" {
  version = "~> 1.0"
  kubernetes {
    config_context = var.kubernetes_context
  }
}

# ------------------------------------------------------------
#   JHUB Helm deployment
# ------------------------------------------------------------
data "helm_repository" "jhub" {
  name = var.helm_repository_name
  url  = var.helm_repository_url
}

resource "kubernetes_namespace" "jhub" {
  metadata {
    name = var.jhub_namespace
  }
}

resource "random_id" "jhub_proxy_token" {
  byte_length = 32
}

# ------------------------------------------------------------
#  TLS (if needed)
# ------------------------------------------------------------
resource "kubernetes_secret" "tls_secret" {
  count = var.create_tls_secret ? 1 : 0

  type = "kubernetes.io/tls"

  metadata {
    name      = var.tls_secret_name
    namespace = var.jhub_namespace
  }

  data = {
    "tls.crt" = "${var.site_certificate}"
    "tls.key" = "${var.site_certificate_key}"
  }

  depends_on = [kubernetes_namespace.jhub]
}

locals {
  nfs_volumes = var.use_shared_volume ? { "nfs-volume" = var.shared_storage_capacity } : {}
}

module "shared-nfs" {
  #When we upgrade to terraform v0.13, the count should live here instead of residing inside every resource in the nfs module
  #count = var.use_shared_volume ? 1 : 0
  source            = "../shared-nfs"
  name              = "shared-storage"
  use_shared_volume = var.use_shared_volume
  namespace         = var.jhub_namespace
  zone              = var.gcp_zone
  project_id        = var.project_id
  volumes           = local.nfs_volumes
}

locals {
  helm_release_wait_condition = length(kubernetes_secret.tls_secret) > 0 ? kubernetes_secret.tls_secret[0].metadata[0].name : kubernetes_namespace.jhub.metadata[0].name
  share_volume_helm = {
    "singleuser.storage.extraVolumes[0].name"                                 = "nfs-volume"
    "singleuser.storage.extraVolumes[0].persistentVolumeClaim.claimName"      = "nfs-volume"
    "singleuser.storage.extraVolumeMounts[0].name"                            = "nfs-volume"
    "singleuser.storage.extraVolumeMounts[0].persistentVolumeClaim.claimName" = "/home/jovyan/shared/"
  }
}

resource "helm_release" "jhub" {

  name       = "jhub"
  repository = data.helm_repository.jhub.metadata[0].name
  chart      = "jupyterhub/jupyterhub"
  version    = var.jhub_helm_version
  namespace  = var.jhub_namespace
  timeout    = var.helm_deploy_timeout

  values = [
    "${file(var.helm_values_file)}"
  ]

  set {
    name  = "proxy.secretToken"
    value = random_id.jhub_proxy_token.hex
  }

  set {
    name  = "proxy.service.loadBalancerIP"
    value = var.static_ip
  }

  set {
    name  = "proxy.https.hosts"
    value = "{${var.jhub_url}}"
  }

  #Authentication
  set {
    name  = "auth.type"
    value = var.auth_type
  }

  #Authentication secrets
  dynamic "set_sensitive" {
    for_each = var.auth_secretkeyvaluemap
    content {
      name  = set_sensitive.key
      value = set_sensitive.value
    }
  }

  # This is to set the NFS-shared related variables 
  # Syntax didn't work out, but we should revisit as having it in the Helm values file doesn't
  # allow us to set the name according to the variables
  #   dynamic "set" {
  #     for_each = var.use_shared_volume == false ? {} : local.share_volume_helm
  #     content {
  #       name  = set.key
  #       value = set.value
  #     }
  #   }

  depends_on = [local.helm_release_wait_condition]
}

# ------------------------------------------------------------
#   CronJobs for scaling an downnscaling during class time
# ------------------------------------------------------------

resource "kubernetes_cluster_role_binding" "cronjob" {

  metadata {
    name = "default-clusterrolebinding"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = var.jhub_namespace
  }

  depends_on = [helm_release.jhub]
}

resource "kubernetes_cron_job" "scale_down" {
  metadata {
    name      = var.scale_down_name
    namespace = var.jhub_namespace
  }
  spec {
    concurrency_policy            = "Allow"
    failed_jobs_history_limit     = 5
    schedule                      = var.scale_down_schedule
    starting_deadline_seconds     = 300
    successful_jobs_history_limit = 10
    suspend                       = false
    job_template {
      metadata {}
      spec {
        # backoff_limit = 10
        template {
          metadata {}
          spec {
            container {
              name    = var.scale_down_name
              image   = "bitnami/kubectl:latest"
              command = var.scale_down_command
            }
            restart_policy                  = "OnFailure"
            automount_service_account_token = var.automount_service_account_token
          }
        }
      }
    }
  }

  depends_on = [helm_release.jhub]
}


resource "kubernetes_cron_job" "scale_up" {
  metadata {
    name      = var.scale_up_name
    namespace = var.jhub_namespace
  }
  spec {
    concurrency_policy            = "Allow"
    failed_jobs_history_limit     = 5
    schedule                      = var.scale_up_schedule
    starting_deadline_seconds     = 300
    successful_jobs_history_limit = 10
    suspend                       = false
    job_template {
      metadata {}
      spec {
        # backoff_limit = 0
        template {
          metadata {}
          spec {
            container {
              name    = var.scale_up_name
              image   = "bitnami/kubectl:latest"
              command = var.scale_up_command
            }
            restart_policy                  = "OnFailure"
            automount_service_account_token = var.automount_service_account_token
          }
        }
      }
    }
  }

  depends_on = [helm_release.jhub]
}

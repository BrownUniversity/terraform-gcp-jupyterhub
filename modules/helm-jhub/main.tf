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
  helm_release_wait_condition = length(kubernetes_secret.tls_secret) > 0 ? kubernetes_secret.tls_secret[0].metadata[0].name : kubernetes_namespace.jhub.metadata[0].name
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

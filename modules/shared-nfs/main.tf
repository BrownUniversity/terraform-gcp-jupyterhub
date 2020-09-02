
resource "kubernetes_secret" "nfs-secret" {
  count = var.use_shared_volume ? 1 : 0
  metadata {
    name = "nfs-secret"
  }
}

#service account for PODs, this service account is for Kubernetes, not Google
resource "kubernetes_service_account" "nfs-sa" {
  count = var.use_shared_volume ? 1 : 0
  metadata {
    name = "nfs-sa"
  }

  secret {
    name = kubernetes_secret.nfs-secret.metadata.0.name
  }
}


# ------------------------------------------------------------
# Volume Claim
# ------------------------------------------------------------

# Dummy name, because terrafor doesn't support empty string 
# See https://github.com/hashicorp/terraform-provider-kubernetes/issues/102

resource "kubernetes_storage_class" "jupyter-storage" {
  count = var.use_shared_volume ? 1 : 0
  metadata {
    name = "jupyter-storage"
  }

  storage_provisioner = "kubernetes.io/gce-pd"

  parameters {
    type = "pd-standard"
  }
}

resource "kubernetes_persistent_volume_claim" "jupyterhub-storage-claim" {
  count = var.use_shared_volume ? 1 : 0

  metadata {
    name = "jupyterhub-storage-claim"
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.jupyter-storage.metadata.0.name

    resources {
      requests {
        storage = var.shared_storage_capacity
      }
    }
  }
}


# ------------------------------------------------------------
# NFS Server for presistant notebooks
# ------------------------------------------------------------

resource "kubernetes_pod" "jupyter-nfs" {
  count = var.use_shared_volume ? 1 : 0
  metadata {
    name = "jupyter-nfs"

    labels {
      app = "jupyter-nfs"
    }
  }

  spec {
    service_account_name = kubernetes_service_account.nfs-sa.metadata.0.name

    container {
      image = "gcr.io/google-samples/nfs-server:1.1"
      name  = "jupyter-nfs-server"

      port {
        name           = "nfs"
        container_port = 2049
      }

      port {
        name           = "mountd"
        container_port = 20048
      }

      port {
        name           = "rpcbind"
        container_port = 111
      }

      volume_mount {
        mount_path = "/exports"
        name       = "nfs-export-volume"
      }

      security_context {
        privileged = true
      }
    }

    volume {
      name = "nfs-export-volume"

      persistent_volume_claim {
        claim_name = kubernetes_persistent_volume_claim.jupyterhub-storage-claim.metadata.0.name
      }
    }
  }
}


## NFS Server Service
resource "kubernetes_service" "jupyter-nfs" {
  metadata {
    name = "jupyter-nfs"
  }

  spec {
    selector {
      app = kubernetes_pod.jupyter-nfs.metadata.0.labels.app
    }

    port {
      name = "nfs"
      port = 2049
    }

    port {
      name = "mountd"
      port = 20048
    }

    port {
      name = "rpcbind"
      port = 111
    }
  }
}

## NFS Server as persistent volume
resource "kubernetes_persistent_volume" "nfs-volume" {
  metadata {
    name = "nfs-volume"
  }

  spec {
    capacity {
      storage = var.shared_storage_capacity
    }

    access_modes = ["ReadWriteMany"]

    persistent_volume_source {
      nfs {
        path   = "/exports"
        server = kubernetes_service.jupyter-nfs.metadata.0.name
      }
    }
  }
}

#resource "kubernetes_persistent_volume_claim" "nfs-volume" {
#  metadata {
#    name = "nfs-volume"
#  }
#
#  spec {
#    access_modes = ["ReadWriteMany"]
#    volume_name = kubernetes_persistent_volume.nfs-volume.metadata.0.name
##    storage_class_name = """"
#    resources {
#      requests {
#        storage = "5Gi"
#      }
#    }
#  }
#}

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google      = ">= 4.72.0, <5.0.0"
    google-beta = ">= 4.72.0, <5.0.0"
    kubernetes  = ">= 2.22.0"
    helm        = ">= 2.10.1"
  }
}

terraform {
  required_version = ">= 1.2.5"

  required_providers {
    google      = ">= 4.31.0, <5.0.0"
    google-beta = ">= 4.31.0, <5.0.0"
    kubernetes  = ">= 2.12"
    helm        = ">= 2.6"
  }
}

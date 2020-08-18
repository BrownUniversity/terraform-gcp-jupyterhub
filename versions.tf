terraform {
  required_version = ">= 0.12"

  required_providers {
    google      = ">= 3.0"
    google-beta = ">= 3.0"
    kubernetes  = ">= 1.4.0"
    helm        = "~> 1.1"
  }
}

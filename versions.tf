terraform {
  required_version = ">= 1.0"

  required_providers {
    google      = ">= 3.0, <4.0.0"
    google-beta = ">= 3.0, <4.0.0"
    kubernetes  = ">= 1.4.0"
    helm        = "~> 1.1"
  }
}

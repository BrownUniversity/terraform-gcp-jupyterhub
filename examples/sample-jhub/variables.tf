variable "org_id" {
}

variable "billing_account" {
}

variable "folder_id" {
}

variable "site_certificate_file" {
  default = "./secrets/tls.cer"
}

variable "site_certificate_key_file" {
  default = "./secrets/tls.key"
}

variable "master_authorized_networks" {
  type = list(object({ cidr_block = string, display_name = string }))
  description = "Defines the CIDR blocks that should be able to connect to the cluster control plane. If empty, no external access is possible"
}

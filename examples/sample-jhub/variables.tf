variable "org_id" {
}

variable "billing_account" {
}

variable "folder_id" {
}

variable "infoblox_username" {
}

variable "infoblox_password" {
}

variable "infoblox_host" {
}

variable "site_certificate_file" {
  default = "./secrets/tls.cer"
}

variable "site_certificate_key_file" {
  default = "./secrets/tls.key"
}

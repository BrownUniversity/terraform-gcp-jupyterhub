variable "org_id" {
  type = string
}

variable "billing_account" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "site_certificate_file" {
  type    = string
  default = "./secrets/tls.cer"
}

variable "site_certificate_key_file" {
  type    = string
  default = "./secrets/tls.key"
}

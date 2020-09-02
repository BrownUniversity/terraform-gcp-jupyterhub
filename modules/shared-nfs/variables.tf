variable "name" {
}

variable "volumes" {
  type = map(number)
}

variable "region" {
#   default = "europe-west1"
}

variable "zone" {
#   default = [
#     "europe-west1-c",
#     "europe-west1-d",
#   ]
}

variable "namespace" {}

variable "annotations" {
  type    = map
  default = {}
}

variable "project_id"{
    
}
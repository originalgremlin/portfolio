variable "profile" {}

variable "shared_credentials_file" {}

variable "hostname" {}

variable "zone_id" {}

variable "logging_bucket" {}

variable "acm_certificate_arn" {}

variable "bucket_names" {
  type = "list"
}

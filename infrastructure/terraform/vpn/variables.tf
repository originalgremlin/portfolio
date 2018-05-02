variable "ami" {}

variable "iam_instance_profile" {}

variable "instance_type" {
  default = "t2.nano"
}

variable "key_pair_name" {}

variable "logging_bucket" {}

variable "elb_external_security_group_ids" {
  type = "list"
}

variable "elb_internal_security_group_ids" {
  type = "list"
}

variable "vpn_security_group_ids" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "private_zone_id" {}

variable "public_subnet_ids" {
  type = "list"
}

variable "public_zone_id" {}

variable "region" {}

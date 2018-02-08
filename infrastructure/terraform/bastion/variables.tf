variable "ami" {}

variable "bastion_security_group_ids" {
  type = "list"
}

variable "elb_security_group_ids" {
  type = "list"
}

variable "iam_instance_profile" {}

variable "instance_type" {
  default = "t2.nano"
}

variable "logging_bucket" {}

variable "subnet_ids" {
  type = "list"
}

variable "zone_id" {}

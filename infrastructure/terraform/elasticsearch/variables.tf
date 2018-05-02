variable "instance_type" {
  default = "t2.medium.elasticsearch"
}

variable "instance_count" {
  default = 2
}

variable "volume_size" {
  default = 10
}

variable "security_group_ids" {
  type = "list"
}

variable "subnet_ids" {
  type = "list"
}

output "bastion" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "bastion")]}",
  ]
}

output "cache" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "cache")]}",
  ]
}

output "database" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "database")]}",
  ]
}

output "dashboard" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "dashboard")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "infra")]}",
  ]
}

output "efs" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "efs")]}",
  ]
}

output "infra" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "infra")]}",
  ]
}

output "elb_bastion" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb_bastion")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb")]}",
  ]
}

output "elb_dashboard" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb_dashboard")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb")]}",
  ]
}

output "elb_logstash" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb_logstash")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb")]}",
  ]
}

output "elb_manager" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb_manager")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb")]}",
  ]
}

output "elb_external_reverse_proxy" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb_external_reverse_proxy")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb")]}",
  ]
}

output "elb_internal_reverse_proxy" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb_internal_reverse_proxy")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb")]}",
  ]
}

output "elb_search" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb_search")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb")]}",
  ]
}

output "elb_swarm_agent" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb_swarm_agent")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb")]}",
  ]
}

output "elb_external_vpn" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb_external_vpn")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb")]}",
  ]
}

output "elb_internal_vpn" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb_internal_vpn")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "elb")]}",
  ]
}

output "lambda_forward_analytics" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "lambda")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "lambda_forward_analytics")]}",
  ]
}

output "logstash" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "infra")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "logstash")]}",
  ]
}

output "manager" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "infra")]}",
  ]
}

output "reverse_proxy" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "infra")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "reverse_proxy")]}",
  ]
}

output "search" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "infra")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "search")]}",
  ]
}

output "simian_army" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "simian_army")]}",
  ]
}

output "swarm_agent" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "infra")]}",
  ]
}

output "vpn" {
  value = [
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "base")]}",
    "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, "vpn")]}",
  ]
}

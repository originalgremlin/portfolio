variable "vpc_id" {}

variable "groups" {
  type = "list"

  default = [
    "base",
    "bastion",
    "dashboard",
    "database",
    "efs",
    "infra",
    "elb_dashboard",
    "elb_manager",
    "elb_reverse_proxy",
    "elb_search",
    "elb_vpn",
    "reverse_proxy",
    "search",
    "simian_army",
    "vpn",
    "elb_bastion",
    "elb_swarm_agent",
    "elb",
    "elb_external_reverse_proxy",
    "elb_internal_reverse_proxy",
    "elb_external_vpn",
    "elb_internal_vpn",
    "cache",
    "elb_internal_storage_agent",
    "storage_agent",
    "certauth",
    "elb_external_certauth",
    "lambda",
    "lambda_forward_analytics",
    "logstash",
    "elb_logstash",
  ]
}

# from_security_group to_security_group port protocol
#
# To another group:
#   base bastion 22 tcp
# To self:
#   infra infra 0 -1
variable "source_security_group_rules" {
  type = "list"

  default = [
    "base efs 0 -1",
    "bastion base 22 tcp",
    "bastion elb 22 tcp",
    "efs base 0 -1",
    "infra cache 6379 tcp",
    "infra database 3306 tcp",
    "infra infra 0 -1",
    "infra elb_manager 4000 tcp",
    "infra elb_manager 8500 tcp",
    "infra elb_search 5044 tcp",
    "infra elb_search 9200 tcp",
    "infra elb_internal_reverse_proxy 80 tcp",
    "elb_bastion bastion 22 tcp",
    "elb_dashboard dashboard 22 tcp",
    "elb_dashboard dashboard 8080 tcp",
    "elb_manager infra 22 tcp",
    "elb_manager infra 4000 tcp",
    "elb_manager infra 8400 tcp",
    "elb_manager infra 8500 tcp",
    "elb_external_vpn vpn 443 tcp",
    "elb_external_reverse_proxy reverse_proxy 80 tcp",
    "elb_external_reverse_proxy reverse_proxy 443 tcp",
    "elb_external_reverse_proxy reverse_proxy 4433 tcp",
    "elb_internal_reverse_proxy reverse_proxy 22 tcp",
    "elb_internal_vpn vpn 22 tcp",
    "elb_search search 22 tcp",
    "elb_search search 5044 tcp",
    "elb_search search 9200 tcp",
    "elb_search search 9300 tcp",
    "elb_swarm_agent infra 22 tcp",
    "elb_swarm_agent infra 2375 tcp",
    "vpn cache 6379 tcp",
    "vpn database 3306 tcp",
    "vpn elb_bastion 22 tcp",
    "vpn elb_dashboard 443 tcp",
    "vpn elb_manager 4000 tcp",
    "vpn elb_manager 8400 tcp",
    "vpn elb_manager 8500 tcp",
    "vpn elb_search 443 tcp",
    "vpn elb_search 9200 tcp",
    "vpn search 9200 tcp",
    "lambda_forward_analytics elb_search 9200 tcp",
    "elb_search search 514 tcp",
    "infra elb_search 514 tcp",
    "elb_logstash logstash 22 tcp",
    "elb_logstash logstash 10000 tcp",
    "elb_logstash logstash 10001 tcp",
    "elb_logstash logstash 10002 tcp",
    "vpn elb_logstash 10000 tcp",
    "vpn elb_logstash 10001 tcp",
    "search elb_logstash 10001 tcp",
    "vpn elb_dashboard 80 tcp",
    "elb_dashboard dashboard 8081 tcp",
  ]
}

# type security_group cidr_block_1,cidr_block_2,... port protocol
#
# Single block:
#   egress base 0.0.0.0/0 123 udp
# Multiple blocks:
#   egress base 8.8.8.8/32,8.8.4.4/32 123 udp
variable "cidr_block_rules" {
  type = "list"

  default = [
    "egress base 0.0.0.0/0 123 udp",
    "egress bastion 0.0.0.0/0 443 tcp",
    "egress infra 0.0.0.0/0 80 tcp",
    "egress infra 0.0.0.0/0 443 tcp",
    "egress simian_army 0.0.0.0/0 443 tcp",
    "egress vpn 0.0.0.0/0 80 tcp",
    "egress vpn 0.0.0.0/0 443 tcp",
    "ingress elb_external_reverse_proxy 0.0.0.0/0 80 tcp",
    "ingress elb_external_reverse_proxy 0.0.0.0/0 443 tcp",
    "ingress elb_external_reverse_proxy 0.0.0.0/0 4433 tcp",
    "ingress elb_external_vpn 0.0.0.0/0 443 tcp",
    "egress lambda 0.0.0.0/0 80 tcp",
    "egress lambda 0.0.0.0/0 443 tcp",
  ]
}

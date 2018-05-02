resource aws_elasticsearch_domain "elasticsearch" {
  domain_name           = "elasticsearch"
  elasticsearch_version = "6.0"

  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    dedicated_master_enabled = false
    zone_awareness_enabled   = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "${var.volume_size}"
  }

  vpc_options {
    security_group_ids = ["${var.security_group_ids}"]
    subnet_ids         = ["${var.subnet_ids}"]
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "*"
        ]
      },
      "Action": [
        "es:*"
      ],
      "Resource": "arn:aws:es:us-east-1:EXAMPLE:domain/elasticsearch/*"
    }
  ]
}
CONFIG
}

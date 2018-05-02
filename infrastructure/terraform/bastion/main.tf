resource "aws_elb" "bastion" {
  name                      = "bastion"
  cross_zone_load_balancing = true
  connection_draining       = true
  internal                  = true
  idle_timeout              = 3600
  security_groups           = ["${var.elb_security_group_ids}"]
  subnets                   = ["${var.subnet_ids}"]

  access_logs {
    bucket        = "${var.logging_bucket}"
    bucket_prefix = "elb/bastion"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    target              = "TCP:22"
    interval            = 20
    timeout             = 3
  }

  listener {
    instance_port     = 22
    instance_protocol = "TCP"
    lb_port           = 22
    lb_protocol       = "TCP"
  }

  tags {
    Name = "bastion"
  }
}

resource "aws_route53_record" "bastion" {
  zone_id = "${var.zone_id}"
  name    = "bastion"
  type    = "A"

  alias {
    name                   = "${aws_elb.bastion.dns_name}"
    zone_id                = "${aws_elb.bastion.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_launch_configuration" "bastion" {
  name_prefix                 = "bastion_"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  security_groups             = ["${var.bastion_security_group_ids}"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/cloud_init.tpl")}"
  enable_monitoring           = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name                 = "${aws_launch_configuration.bastion.name}"
  max_size             = 1
  min_size             = 1
  min_elb_capacity     = 1
  launch_configuration = "${aws_launch_configuration.bastion.name}"
  health_check_type    = "ELB"
  load_balancers       = ["${aws_elb.bastion.name}"]
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  enabled_metrics      = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

  tag {
    key                 = "Name"
    value               = "bastion"
    propagate_at_launch = true
  }

  tag {
    key                 = "DiscoveryName"
    value               = "bastion"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

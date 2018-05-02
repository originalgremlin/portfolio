resource "aws_elb" "elb_external" {
  name                      = "vpn-external"
  cross_zone_load_balancing = true
  connection_draining       = true
  idle_timeout              = 3600
  security_groups           = ["${var.elb_external_security_group_ids}"]
  subnets                   = ["${var.public_subnet_ids}"]

  access_logs {
    bucket        = "${var.logging_bucket}"
    bucket_prefix = "elb/vpn_external"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    target              = "TCP:443"
    interval            = 20
    timeout             = 3
  }

  listener {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }

  tags {
    Name = "vpn_external"
  }
}

resource "aws_elb" "elb_internal" {
  name                      = "vpn-internal"
  cross_zone_load_balancing = true
  connection_draining       = true
  internal                  = true
  idle_timeout              = 3600
  security_groups           = ["${var.elb_internal_security_group_ids}"]
  subnets                   = ["${var.private_subnet_ids}"]

  access_logs {
    bucket        = "${var.logging_bucket}"
    bucket_prefix = "elb/vpn_internal"
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
    Name = "vpn_internal"
  }
}

resource "aws_route53_record" "vpn_internal" {
  zone_id = "${var.private_zone_id}"
  name    = "vpn"
  type    = "A"

  alias {
    name                   = "${aws_elb.elb_internal.dns_name}"
    zone_id                = "${aws_elb.elb_internal.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "vpn" {
  zone_id = "${var.public_zone_id}"
  name    = "vpn.${var.region}"
  type    = "A"

  alias {
    name                   = "${aws_elb.elb_external.dns_name}"
    zone_id                = "${aws_elb.elb_external.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_launch_configuration" "vpn" {
  name_prefix                 = "vpn_"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  key_name                    = "${var.key_pair_name}"
  security_groups             = ["${var.vpn_security_group_ids}"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/cloud_init.tpl")}"
  enable_monitoring           = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "vpn" {
  name                      = "${aws_launch_configuration.vpn.name}"
  max_size                  = "8"
  min_size                  = "2"
  launch_configuration      = "${aws_launch_configuration.vpn.name}"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = ["${aws_elb.elb_external.name}", "${aws_elb.elb_internal.name}"]
  vpc_zone_identifier       = ["${var.private_subnet_ids}"]
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  protect_from_scale_in     = false

  tag {
    key                 = "Name"
    value               = "vpn"
    propagate_at_launch = true
  }

  tag {
    key                 = "DiscoveryName"
    value               = "vpn"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# TODO convert from CPU-based alarms to networking
# TODO max for a t2.small is ~125Mbits/s.  what is an 80%/60% average of that over the 120 second period?
# TODO i.e. how do I set my bounds?
# http://stackoverflow.com/questions/18507405/ec2-instance-typess-exact-network-performance
resource "aws_autoscaling_policy" "vpn" {
  name                    = "vpn"
  autoscaling_group_name  = "${aws_autoscaling_group.vpn.name}"
  adjustment_type         = "ChangeInCapacity"
  metric_aggregation_type = "Average"
  policy_type             = "StepScaling"

  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_upper_bound = 60.0
  }

  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_lower_bound = 60.0
    metric_interval_upper_bound = 80.0
  }

  step_adjustment {
    scaling_adjustment          = 2
    metric_interval_lower_bound = 80.0
  }
}

resource "aws_cloudwatch_metric_alarm" "vpn_cpu_down" {
  alarm_name                = "vpn_cpu_down"
  alarm_description         = "vpn cpu utilization"
  comparison_operator       = "LessThanOrEqualToThreshold"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  evaluation_periods        = 2
  period                    = 120
  statistic                 = "Average"
  threshold                 = 60
  actions_enabled           = true
  alarm_actions             = ["${aws_autoscaling_policy.vpn.arn}"]
  ok_actions                = ["${aws_autoscaling_policy.vpn.arn}"]
  insufficient_data_actions = ["${aws_autoscaling_policy.vpn.arn}"]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.vpn.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "vpn_cpu_up" {
  alarm_name                = "vpn_cpu_up"
  alarm_description         = "vpn cpu utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  evaluation_periods        = 2
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  actions_enabled           = true
  alarm_actions             = ["${aws_autoscaling_policy.vpn.arn}"]
  ok_actions                = ["${aws_autoscaling_policy.vpn.arn}"]
  insufficient_data_actions = ["${aws_autoscaling_policy.vpn.arn}"]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.vpn.name}"
  }
}

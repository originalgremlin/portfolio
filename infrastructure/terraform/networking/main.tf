resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "default"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "default"
  }
}

# --- private subnet ---
# 10.0.0.0/20
# 10.0.16.0/20
# 10.0.32.0/20
# 10.0.48.0/20
resource "aws_subnet" "private" {
  count                   = "${var.count_subnets}"
  cidr_block              = "${cidrsubnet(var.cidr_block, 4, count.index)}"
  availability_zone       = "${var.availability_zones[count.index]}"
  map_public_ip_on_launch = false
  vpc_id                  = "${aws_vpc.default.id}"

  tags {
    Name             = "private ${var.availability_zones[count.index]}"
    AvailabilityZone = "${var.availability_zones[count.index]}"
  }
}

resource "aws_eip" "nat_gateway" {
  count = "${var.count_subnets}"
  vpc   = true
}

resource "aws_nat_gateway" "private" {
  count         = "${var.count_subnets}"
  allocation_id = "${element(aws_eip.nat_gateway.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_route_table" "private" {
  count  = "${var.count_subnets}"
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.private.*.id, count.index)}"
  }

  tags {
    Name = "private ${var.availability_zones[count.index]}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${var.count_subnets}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

# --- public subnet ---
# 10.0.128.0/22
# 10.0.132.0/22
# 10.0.136.0/22
# 10.0.140.0/22
#
# NOTE:
# cidrsubnet() is a confusing function :[
# The intent of the cidr_block is to start at .128.0 (i.e. cidrsubnet(var.cidr_block, 4, 8))
# and continue incrementing by .4.0 for each new subnet (cidrsubnet(..., 2, count.index).
# Thus, assuming the vpc_cidr is 10.0.0.0/16, we calculate 10.0.128.0/22, 10.0.132.0/22, 10.0.136.0/22, and 10.0.140.0/22.
resource "aws_subnet" "public" {
  count                   = "${var.count_subnets}"
  cidr_block              = "${cidrsubnet(cidrsubnet(var.cidr_block, 4, 8), 2, count.index)}"
  availability_zone       = "${var.availability_zones[count.index]}"
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.default.id}"

  tags {
    Name             = "public ${element(var.availability_zones, count.index)}"
    AvailabilityZone = "${element(var.availability_zones, count.index)}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${var.count_subnets}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

# --- flow logs ---
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name = "vpc_flow_logs"
}

resource "aws_iam_role" "vpc_flow_logs" {
  name               = "vpc_flow_logs"
  assume_role_policy = "{\"Version\": \"2012-10-17\",\"Statement\": [{\"Sid\": \"\", \"Effect\": \"Allow\", \"Principal\": {\"Service\": \"vpc-flow-logs.amazonaws.com\"}, \"Action\": \"sts:AssumeRole\"}]}"
}

resource "aws_iam_role_policy" "vpc_flow_logs" {
  name   = "vpc_flow_logs"
  role   = "${aws_iam_role.vpc_flow_logs.id}"
  policy = "{\"Version\": \"2012-10-17\",\"Statement\": [{\"Action\": [\"logs:CreateLogGroup\", \"logs:CreateLogStream\", \"logs:PutLogEvents\", \"logs:DescribeLogGroups\", \"logs:DescribeLogStreams\"], \"Effect\": \"Allow\", \"Resource\": \"*\"}]}"
}

resource "aws_flow_log" "vpc" {
  log_group_name = "${aws_cloudwatch_log_group.vpc_flow_logs.name}"
  iam_role_arn   = "${aws_iam_role.vpc_flow_logs.arn}"
  vpc_id         = "${aws_vpc.default.id}"
  traffic_type   = "ALL"
}

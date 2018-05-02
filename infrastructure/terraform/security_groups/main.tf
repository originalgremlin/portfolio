resource "aws_security_group" "group" {
  count       = "${length(var.groups)}"
  name        = "${var.groups[count.index]}"
  description = "${var.groups[count.index]}"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.groups[count.index]}"
  }
}

resource "aws_security_group_rule" "source_security_group_egress_rule" {
  count                    = "${length(var.source_security_group_rules)}"
  type                     = "egress"
  security_group_id        = "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, element(split(" ", var.source_security_group_rules[count.index]), 0))]}"
  source_security_group_id = "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, element(split(" ", var.source_security_group_rules[count.index]), 1))]}"
  from_port                = "${element(split(" ", var.source_security_group_rules[count.index]), 2)}"
  to_port                  = "${element(split(" ", var.source_security_group_rules[count.index]), 2)}"
  protocol                 = "${element(split(" ", var.source_security_group_rules[count.index]), 3)}"
}

resource "aws_security_group_rule" "source_security_group_ingress_rule" {
  count                    = "${length(var.source_security_group_rules)}"
  type                     = "ingress"
  security_group_id        = "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, element(split(" ", var.source_security_group_rules[count.index]), 1))]}"
  source_security_group_id = "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, element(split(" ", var.source_security_group_rules[count.index]), 0))]}"
  from_port                = "${element(split(" ", var.source_security_group_rules[count.index]), 2)}"
  to_port                  = "${element(split(" ", var.source_security_group_rules[count.index]), 2)}"
  protocol                 = "${element(split(" ", var.source_security_group_rules[count.index]), 3)}"
}

resource "aws_security_group_rule" "cidr_block_rule" {
  count             = "${length(var.cidr_block_rules)}"
  type              = "${element(split(" ", var.cidr_block_rules[count.index]), 0)}"
  security_group_id = "${aws_security_group.group.*.id[index(aws_security_group.group.*.name, element(split(" ", var.cidr_block_rules[count.index]), 1))]}"
  cidr_blocks       = "${split(",", element(split(" ", var.cidr_block_rules[count.index]), 2))}"
  from_port         = "${element(split(" ", var.cidr_block_rules[count.index]), 3)}"
  to_port           = "${element(split(" ", var.cidr_block_rules[count.index]), 3)}"
  protocol          = "${element(split(" ", var.cidr_block_rules[count.index]), 4)}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "private_subnet_cidr_blocks" {
  value = ["${aws_subnet.private.*.cidr_block}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnet_cidr_blocks" {
  value = ["${aws_subnet.public.*.cidr_block}"]
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

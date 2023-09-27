output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public[0].id}"
}
output "private_subnet_id" {
  value = "${aws_subnet.private[0].id}"
}
output "private-sg_id" {
  value = "${aws_security_group.private-sg.id}"
}
output "public-sg_id" {
  value = "${aws_security_group.public-sg.id}"
}
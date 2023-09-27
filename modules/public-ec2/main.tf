resource "aws_instance" "server" {
  count         = "${var.ec2_count}"
  ami           = "${var.ami_id}"
  key_name      = "${var.key_name}" 
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"
  user_data     = var.user_data
  vpc_security_group_ids = [var.vpc_security_group_ids]
  

  tags ={
    Name = "public-instance"
  }
}
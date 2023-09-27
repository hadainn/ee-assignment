variable "ec2_count" {
  default = "1"
}
variable "key_name" {
   type = string
  default = "eetest-key"
}
variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "environment" {
  type        = string

}

variable "subnet_id" {

}
variable "ami_id" {}
variable "user_data" {
  type        = string
    
}
variable "vpc_security_group_ids" {
}
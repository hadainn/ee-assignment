variable "vpc_name"{
    default = "ee-vpc"
}
variable "vpc_cidr" {

}
variable "environment" {
    default = "prod"
}
variable "gw_name"{
    default = "prod-gw"
}
variable "nat_eip_name" {
    default = "prod-eip"
}
variable "nat_gateway_name" {
    default = "prod-netgateway"
}
variable "public_subnet_cidr_blocks" {
  default = "10.0.101.0/24"
}
variable "private_subnet_cidr_blocks" {
  default = "10.0.1.0/24"
}
variable "availability_zones" {
  type        = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "public_subnet_name" {
    default = "public-subnet-prod"
}
variable "private_subnet_name" {
    default = "private-subnet-prod"
}
variable "public_rt_name" {
    default = "public-rt"
}
variable "private_rt_name" {
    default = "private-rt"
}
variable "public-sg" {

}
variable "private-sg" {
   
}
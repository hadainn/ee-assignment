module "ee_vpc" {
  source                     = "../modules/vpc"
  environment                = "prod"
  vpc_cidr                   = "10.0.0.0/16"
  gw_name                    = "prod-gw"
  nat_eip_name               = "prod-eip"
  nat_gateway_name           = "prod-gw"
  public_subnet_cidr_blocks  = "10.0.101.0/24"
  private_subnet_cidr_blocks = "10.0.1.0/24"
  availability_zones         = ["us-east-1a", "us-east-1b"]
  public_rt_name             = "public-prod-rt"
  private_rt_name            = "private-prod-rt"
  private-sg                 = "prod-private-sg"
  public-sg                  = "prod-public-sg"
}
module "public-ec2" {
  source        = "../modules/public-ec2"
  ec2_count     = 1
  environment   = "prod"
  ami_id        = "ami-005b11f8b84489615" 
  instance_type = "t2.micro"
  key_name      = "eetest-key"
  subnet_id     = "${module.ee_vpc.public_subnet_id}"
  user_data    =  filebase64("jenkins.sh")
  vpc_security_group_ids = "${module.ee_vpc.public-sg_id}"
}
module "private-ec2" {
  source        = "../modules/private-ec2"
  ec2_count     = 1
  environment   = "prod"
  ami_id        = "ami-005b11f8b84489615" 
  instance_type = "t2.micro"
  subnet_id     = "${module.ee_vpc.private_subnet_id}"
  user_data     =  filebase64("docker-install.sh")
  vpc_security_group_ids = "${module.ee_vpc.private-sg_id}"
}
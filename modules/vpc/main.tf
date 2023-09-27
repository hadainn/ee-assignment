# Creating VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
     Name = var.vpc_name
    Environment = var.environment
  }
}

# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.gw_name
  }
}

# Creating Public Subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_blocks
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zones[count.index]
  count = 1
  tags = {
     Name = var.public_subnet_name
     Environment = var.environment
  }
}
# Creating Private Subnets
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr_blocks
  availability_zone = var.availability_zones[count.index]
  count = 1
  tags = {
    Name = var.private_subnet_name
    Environment = var.environment
  }
}

# Creating public Route Tables 
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = var.public_rt_name
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.public.id
}

# Creating private Route Tables
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.private_rt_name
  }
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.private.id
}
# Create elastic IP
resource "aws_eip" "nat_eip" {
    depends_on = [aws_vpc.vpc]
  tags = {
    Name = var.nat_eip_name
  }
}
# Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id  = aws_eip.nat_eip.id
  subnet_id      = aws_subnet.public[0].id

  tags = {
    Name = var.nat_gateway_name
  }
}
resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}
# Create security group for nodes
resource "aws_security_group" "public-sg" {
  name        = var.public-sg
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = var.public-sg
    Environment = var.environment
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 8080
    to_port         = 9090
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port    = 22
    to_port      = 22
    protocol     = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "private-sg" {
  name        = var.private-sg
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = var.private-sg
    Environment = var.environment
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port    = 22
    to_port      = 22
    protocol     = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
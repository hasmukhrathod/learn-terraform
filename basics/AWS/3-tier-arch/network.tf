
#------------1. create VPC-----------------
resource "aws_vpc" "vpc_details" {
  provider             = aws.us-east
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.vpc_dns_support
  enable_dns_hostnames = var.vpc_dns_hostname
  tags = {
    Name = "${var.project_env}-${var.project_name}-vpc"
  }
}

#--------------2.Create IGW------------------
resource "aws_internet_gateway" "igw_details" {
  provider = aws.us-east
  vpc_id   = aws_vpc.vpc_details.id
  tags = {
    Name = "${var.project_env}-${var.project_name}-igw"
  }
}


#--------------3.Create internet route table-------------
resource "aws_route_table" "internet_route_table" {
  provider = aws.us-east
  vpc_id   = aws_vpc.vpc_details.id
  route {
    cidr_block = var.internet_access
    gateway_id = aws_internet_gateway.igw_details.id
  }
  ##ignore changes
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "${var.project_env}-${var.project_name}-internet-rtb"
  }
}

#------------4.Create internal route table-----------------
resource "aws_route_table" "internal_route_table" {
  provider = aws.us-east
  vpc_id   = aws_vpc.vpc_details.id
  route {
    cidr_block     = var.internet_access
    nat_gateway_id = aws_nat_gateway.web_tier_subnet2_az2_nat_gateway.id
  }
  ##ignore changes
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "${var.project_env}-${var.project_name}-internal-rtb"
  }
}

#-------------5.Get all AZs & Create Subnets-----------------------
data "aws_availability_zones" "get_azs" {
  provider = aws.us-east
  state    = "available"
}

#Create web-tier subnet1
resource "aws_subnet" "web_tier_subnet1_az1" {
  provider          = aws.us-east
  availability_zone = element(data.aws_availability_zones.get_azs.names, 0)
  vpc_id            = aws_vpc.vpc_details.id
  cidr_block        = var.web_tier_subnet1_az1
  tags = {
    Name = "${var.project_env}-${var.project_name}-web-tier-subnet1-az1"
  }
}

#Create web-tier subnet2
resource "aws_subnet" "web_tier_subnet2_az2" {
  provider          = aws.us-east
  availability_zone = element(data.aws_availability_zones.get_azs.names, 1)
  vpc_id            = aws_vpc.vpc_details.id
  cidr_block        = var.web_tier_subnet2_az2
  tags = {
    Name = "${var.project_env}-${var.project_name}-web-tier-subnet2-az2"
  }
}

#Create app-tier subnet1
resource "aws_subnet" "app_tier_subnet1_az1" {
  provider          = aws.us-east
  availability_zone = element(data.aws_availability_zones.get_azs.names, 0)
  vpc_id            = aws_vpc.vpc_details.id
  cidr_block        = var.app_tier_subnet1_az1
  tags = {
    Name = "${var.project_env}-${var.project_name}-app-tier-subnet1-az1"
  }
}

#Create app-tier subnet2
resource "aws_subnet" "app_tier_subnet2_az2" {
  provider          = aws.us-east
  availability_zone = element(data.aws_availability_zones.get_azs.names, 1)
  vpc_id            = aws_vpc.vpc_details.id
  cidr_block        = var.app_tier_subnet2_az2
  tags = {
    Name = "${var.project_env}-${var.project_name}-app-tier-subnet2-az2"
  }
}

#Create db-tier subnet1
resource "aws_subnet" "db_tier_subnet1_az1" {
  provider          = aws.us-east
  availability_zone = element(data.aws_availability_zones.get_azs.names, 0)
  vpc_id            = aws_vpc.vpc_details.id
  cidr_block        = var.db_tier_subnet1_az1
  tags = {
    Name = "${var.project_env}-${var.project_name}-db-tier-subnet1-az1"
  }
}

#Create db-tier subnet2
resource "aws_subnet" "db_tier_subnet2_az2" {
  provider          = aws.us-east
  availability_zone = element(data.aws_availability_zones.get_azs.names, 1)
  vpc_id            = aws_vpc.vpc_details.id
  cidr_block        = var.db_tier_subnet2_az2
  tags = {
    Name = "${var.project_env}-${var.project_name}-db-tier-subnet2-az2"
  }
}

#---------------------6.Route-table & Subnet associations------------------------

resource "aws_route_table_association" "web_tier_subnet1" {
  provider       = aws.us-east
  subnet_id      = aws_subnet.web_tier_subnet1_az1.id
  route_table_id = aws_route_table.internet_route_table.id
}
resource "aws_route_table_association" "web_tier_subnet2" {
  provider       = aws.us-east
  subnet_id      = aws_subnet.web_tier_subnet2_az2.id
  route_table_id = aws_route_table.internet_route_table.id
}
resource "aws_route_table_association" "app_tier_subnet1" {
  provider       = aws.us-east
  subnet_id      = aws_subnet.app_tier_subnet1_az1.id
  route_table_id = aws_route_table.internal_route_table.id
}
resource "aws_route_table_association" "app_tier_subnet2" {
  provider       = aws.us-east
  subnet_id      = aws_subnet.app_tier_subnet2_az2.id
  route_table_id = aws_route_table.internal_route_table.id
}
resource "aws_route_table_association" "db_tier_subnet1" {
  provider       = aws.us-east
  subnet_id      = aws_subnet.db_tier_subnet1_az1.id
  route_table_id = aws_route_table.internal_route_table.id
}
resource "aws_route_table_association" "db_tier_subnet2" {
  provider       = aws.us-east
  subnet_id      = aws_subnet.db_tier_subnet2_az2.id
  route_table_id = aws_route_table.internal_route_table.id
}


#--------------------------7. NAT Gateway ------------------------------------
resource "aws_eip" "web_tier_nat_gateway_eip" {
  provider = aws.us-east
  vpc      = true
}

resource "aws_nat_gateway" "web_tier_subnet2_az2_nat_gateway" {
  provider      = aws.us-east
  allocation_id = aws_eip.web_tier_nat_gateway_eip.id
  subnet_id     = aws_subnet.web_tier_subnet2_az2.id

  tags = {
    Name = "${var.project_env}-${var.project_name}-nat-gw"
  }
}




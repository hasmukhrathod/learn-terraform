
#create VPC
resource "aws_vpc" "vpc_production" {
  provider             = aws.production
  cidr_block           = "192.168.0.0/22"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "project-production-vpc"
  }
}

#Create IGW
resource "aws_internet_gateway" "igw_production" {
  provider = aws.production
  vpc_id   = aws_vpc.vpc_production.id
  tags = {
    Name = "project-production-igw"
  }
}

#Create route table
resource "aws_route_table" "internet_route" {
  provider = aws.production
  vpc_id   = aws_vpc.vpc_production.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_production.id
  }
  ##ignore changes
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "project-production-internet-route-table"
  }
}


#Get all AZs
data "aws_availability_zones" "azs" {
  provider = aws.production
  state    = "available"
}

#Create subnet1
resource "aws_subnet" "subnet_1" {
  provider          = aws.production
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_production.id
  cidr_block        = "192.168.0.0/24"
  tags = {
    Name = "project-production-public-subnet-1"
  }
}

#Create subnet2
resource "aws_subnet" "subnet_2" {
  provider          = aws.production
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_production.id
  cidr_block        = "192.168.1.0/24"
  tags = {
    Name = "project-production-public-subnet-2"
  }
}

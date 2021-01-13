# CREATE SG LB
resource "aws_security_group" "production-lb" {
  provider    = aws.production
  name        = "production-lb"
  description = "Allow internet access"
  vpc_id      = aws_vpc.vpc_production.id
  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.internet_access]
  }

  ingress {
    description = "HTTP from Internet"
    from_port   = var.webserver-port
    to_port     = var.webserver-port
    protocol    = "tcp"
    cidr_blocks = [var.internet_access]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_access]
  }

  tags = {
    Name = "project-production-lb-sg"
  }
}


# CREATE SG WebServer
resource "aws_security_group" "web_server_sg" {
  provider    = aws.production
  name        = "WebServer-sg"
  description = "SG for WebServer"
  vpc_id      = aws_vpc.vpc_production.id
  ingress {
    description = "Allow SSH from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.internet_access]
  }

  tags = {
    Name = "project-production-web-server-sg"
  }
}




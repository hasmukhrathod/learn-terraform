# SG for web-tier Load balancer.
resource "aws_security_group" "web_tier_lb_sg" {
  provider    = aws.us-east
  name        = "web_tier_lb_sg"
  description = "Allow internet access"
  vpc_id      = aws_vpc.vpc_details.id
  ingress {
    description = "HTTPS from Internet"
    from_port   = var.webserver_https_port
    to_port     = var.webserver_https_port
    protocol    = "tcp"
    cidr_blocks = [var.internet_access]
  }

  ingress {
    description = "HTTP from Internet"
    from_port   = var.webserver_http_port
    to_port     = var.webserver_http_port
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
    Name = "${var.project_env}-${var.project_name}-lb-sg"
  }
}


# SG for bastion-host
resource "aws_security_group" "bastion_host_sg" {
  provider    = aws.us-east
  name        = "bastion_host_sg"
  description = "SG for bastion host"
  vpc_id      = aws_vpc.vpc_details.id
  ingress {
    description = "Allow SSH from office n/w of home IP"
    from_port   = var.webserver_ssh_port
    to_port     = var.webserver_ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.whitelisted_ip]
  }
  ingress {
    description = "HTTPS from Internet"
    #from_port       = var.webserver_https_port
    #to_port         = var.webserver_https_port
    #protocol        = "tcp"
    from_port       = var.webserver_http_port
    to_port         = var.webserver_http_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web_tier_lb_sg.id]
    #cidr_blocks = [var.internet_access]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_access]
  }

  tags = {
    Name = "${var.project_env}-${var.project_name}-bastion-host-sg"
  }
}

# SG for app-servers
resource "aws_security_group" "app_servers_sg" {
  provider    = aws.us-east
  name        = "app_servers_sg"
  description = "SG for app servers"
  vpc_id      = aws_vpc.vpc_details.id
  
  ingress {
    description     = "Allow SSH from office n/w of home IP"
    from_port       = var.webserver_ssh_port
    to_port         = var.webserver_ssh_port
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }
 
  ingress {
    description = "HTTP from Internet"
    from_port   = var.webserver_http_port
    to_port     = var.webserver_http_port
    protocol    = "tcp"
    #from_port       = 0
    #to_port         = 0
    #protocol        = -1
    security_groups = [aws_security_group.web_tier_lb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_access]
  }

  tags = {
    Name = "${var.project_env}-${var.project_name}-app-servers-sg"
  }
}

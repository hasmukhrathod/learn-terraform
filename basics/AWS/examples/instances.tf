#GET LINUX AMI ID using SSM parameter in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.production
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Import public key for logging into EC2 us-east-1
resource "aws_key_pair" "pub-key" {
  provider   = aws.production
  key_name   = "my-login-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web_server" {
  provider = aws.production
  #count = var.instance-count
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.pub-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  subnet_id                   = aws_subnet.subnet_1.id
  tags = {
    Name = "WebServer"
  }
  #depends_on = []
}

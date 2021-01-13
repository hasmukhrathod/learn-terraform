#GET LINUX AMI ID using SSM parameter in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.us-east
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Import public key for logging into EC2 us-east-1
resource "aws_key_pair" "pub_key" {
  provider   = aws.us-east
  key_name   = "my_ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "bastion_host_server" {
  provider = aws.us-east
  ami      = data.aws_ssm_parameter.linuxAmi.value
  #ami = "ami-0885b1f6bd170450c"
  #instance_type               = var.instance_type
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.pub_key.key_name
  associate_public_ip_address = var.public_ip_attach_true #default value for this key is false.
  vpc_security_group_ids      = [aws_security_group.bastion_host_sg.id]
  subnet_id                   = aws_subnet.web_tier_subnet1_az1.id
  user_data                   = file("install_apache.sh")

  tags = {
    Name = "${var.project_env}-${var.project_name}-bastion-server"
  }
  #depends_on = []
}



resource "aws_instance" "app_server_subnet1_az1" {
  provider      = aws.us-east
  ami           = data.aws_ssm_parameter.linuxAmi.value
  instance_type = var.instance_type
  key_name      = aws_key_pair.pub_key.key_name
  #associate_public_ip_address = var.public_ip_attach_true
  vpc_security_group_ids = [aws_security_group.app_servers_sg.id]
  subnet_id              = aws_subnet.app_tier_subnet1_az1.id
  user_data              = file("install_apache.sh")

  tags = {
    Name = "${var.project_env}-${var.project_name}-app-server-az1"
  }
  #depends_on = []
}




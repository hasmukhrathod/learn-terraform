resource "aws_instance" "cerberus" {
    ami = var.ami
    instance_type = var.instance_type
    user_data = file("./install-nginx.sh")

}
resource "aws_key_pair" "cerberus-key" {
    key_name = "cerberus"
    public_key = file(".ssh/cerberus.pub")
}
resource "aws_eip" "eip" {
    vpc = true
    instance = aws_instance.cerberus.id
    provisioner "local-exec" {
      command = "echo ${aws_eip.eip.public_dns} >> /root/cerberus_public_dns.txt"
    }

}
variable "ami" {
  default = "ami-06178cf087598769c"
}
variable "instance_type" {
    default = "m5.large"

}
variable "region" {
  default = "eu-west-2"
}

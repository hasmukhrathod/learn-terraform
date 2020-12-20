resource "aws_instance" "web-server" {
  ami = "ami-06178cf087598769c"
  instance_type = "m5.large"

}

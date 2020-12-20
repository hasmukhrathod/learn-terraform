resource "aws_instance" "web-server" {
  ami = "ami-06178cf087598769c"
  instance_type = "m5.large"
  key_name = aws_key_pair.my-public-key.id
  user_data = file("install-nginx.sh")
}

resource "aws_key_pair" "my-public-key" {
  key_name = "web-server-public-key"
  public_key = file("PATH_TO_PUBLIC_KEY.pub")

}

resource "aws_eip" "eip" {
  instance = aws_instance.web-server.id
  vpc      = true
}

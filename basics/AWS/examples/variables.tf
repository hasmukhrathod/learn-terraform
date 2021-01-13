variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}
variable "internet_access" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance-count" {
  type    = number
  default = 1
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "webserver-port" {
  type = number
  default = 80
}

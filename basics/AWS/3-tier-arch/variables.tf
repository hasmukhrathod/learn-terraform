#-----------------Tag related variables------------------
variable "project_name" {
  type    = string
  default = "my-product"
}

variable "project_env" {
  type    = string
  default = "staging"
}

#--------------Credentials realted variables--------------
variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

#--------------Network related variables----------------
variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/20"
}
variable "vpc_dns_support" {
  type    = bool
  default = true
}

variable "vpc_dns_hostname" {
  type    = bool
  default = true
}

#-----------Subnets of all 3 tiers in AZ1---------------
#2 subnet in spare for future usecases.
variable "web_tier_subnet1_az1" {
  type    = string
  default = "192.168.0.0/24"
}
variable "app_tier_subnet1_az1" {
  type    = string
  default = "192.168.2.0/24"
}
variable "db_tier_subnet1_az1" {
  type    = string
  default = "192.168.4.0/24"
}

#------------Subnet of all 3 tiers in AZ2-------------------
#2 subnets in spare for future usecases.
variable "web_tier_subnet2_az2" {
  type    = string
  default = "192.168.8.0/24"
}
variable "app_tier_subnet2_az2" {
  type    = string
  default = "192.168.10.0/24"
}
variable "db_tier_subnet2_az2" {
  type    = string
  default = "192.168.12.0/24"
}


#----------web-sever related variables--------------
variable "internet_access" {
  type    = string
  default = "0.0.0.0/0"
}

variable "whitelisted_ip" {
  type        = string
  description = "specify office n/w ip or home ip here"
  default     = "0.0.0.0/0"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "webserver_http_port" {
  type    = number
  default = 80
}

variable "webserver_https_port" {
  type    = number
  default = 443
}

variable "webserver_ssh_port" {
  type    = number
  default = 22
}

variable "public_ip_attach_true" {
  type    = bool
  default = true
}
#------------------ALB related variables ---------------
variable "alb_name" {
  type    = string
  default = "app-tier-alb"
}
variable "not_internal" {
  type    = bool
  default = false
}
variable "lb_type" {
  type    = string
  default = "application"
}
variable "alb_listner_http_port" {
  type    = string
  default = "80"
}
variable "alb_listner_http_protocol" {
  type    = string
  default = "HTTP"
}
variable "alb_listner_action_type" {
  type    = string
  default = "forward"
}
variable "app_tier_alb_tg_group_name" {
  type    = string
  default = "app-tier-alb-tg-group"
}
variable "app_tier_alb_tg_group_type" {
  type    = string
  default = "instance"
}
variable "app_tier_alb_tg_group_protocol" {
  type    = string
  default = "HTTP"
}
variable "app_tier_alb_tg_group_hcheck_enabled_status" {
  type    = bool
  default = true
}
variable "app_tier_alb_tg_group_hcheck_interval" {
  type    = number
  default = 10
}
variable "app_tier_alb_tg_group_hcheck_path" {
  type    = string
  default = "/"
}
variable "app_tier_alb_tg_group_hcheck_port" {
  type    = string
  default = "80"
}
variable "app_tier_alb_tg_group_hcheck_protocol" {
  type    = string
  default = "HTTP"
}
variable "app_tier_alb_tg_group_hcheck_matcher" {
  type    = string
  default = "200-299"
}


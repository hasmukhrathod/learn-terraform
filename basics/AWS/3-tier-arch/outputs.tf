
output "bastion-host-ip" {
  value = aws_instance.bastion_host_server.public_ip
}


output "alb_dns" {
  value = aws_lb.app_tier_alb.dns_name
}


output "app-server-ip" {
  value = aws_instance.app_server_subnet1_az1.private_ip
}
output "nat_gateway_ip" {
  value = aws_eip.web_tier_nat_gateway_eip.public_ip
}


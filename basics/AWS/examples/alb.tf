resource "aws_lb" "application-lb" {
  provider = aws.production
  name = "web-elb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.production-lb.id]
  subnets = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  tags = {
    Name = "WEB-ALB"
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  provider = aws.production
  name = "app-lb-tg"
  port = var.webserver-port
  target_type = "instance"
  vpc_id = aws_vpc.vpc_production.id
  protocol = "HTTP"
  health_check {
    enabled = true
    interval = 10
    path = "/"
    port = var.webserver-port
    protocol = "HTTP"
   matcher = "200-299"
  }
  tags = {
    Name = "lb-target-group"
  }

}

resource "aws_lb_listner" "lb-listner-group" {
  provider = aws.production
  load_balancer_arn = aws_lb.application-lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
   type = "forward"
   target_group_arn = aws_lb_target_group.app-lb-tg.id
  }
}


resource "aws_lb_target_group_attachment" "attach-lb" {
  provider = aws.production
  target_group_arn = aws_lbtarget_group.app-lb-tg.arn
  target_id = aws_instance.production.id
  port = var.webserver-port
}


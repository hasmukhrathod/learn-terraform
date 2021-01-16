resource "aws_lb" "app_tier_alb" {
  provider           = aws.us-east
  name               = var.alb_name
  internal           = var.not_internal
  load_balancer_type = var.lb_type
  #subnets            = [aws_subnet.app_tier_subnet1_az1.id, aws_subnet.app_tier_subnet2_az2.id]
  security_groups = [aws_security_group.web_tier_lb_sg.id]
  subnets         = [aws_subnet.web_tier_subnet1_az1.id, aws_subnet.web_tier_subnet2_az2.id]
  tags = {
    Name = "${var.project_env}-${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "app_tier_alb_tg_group" {
  provider    = aws.us-east
  name        = var.app_tier_alb_tg_group_name
  port        = var.webserver_http_port
  target_type = var.app_tier_alb_tg_group_type
  vpc_id      = aws_vpc.vpc_details.id
  protocol    = var.app_tier_alb_tg_group_protocol
  health_check {
    enabled  = var.app_tier_alb_tg_group_hcheck_enabled_status
    interval = var.app_tier_alb_tg_group_hcheck_interval
    #path     = var.app_tier_alb_tg_group_hcheck_path
    path     = "/var/www/html/index.html"
    port     = var.app_tier_alb_tg_group_hcheck_port
    protocol = var.app_tier_alb_tg_group_hcheck_protocol
    matcher  = var.app_tier_alb_tg_group_hcheck_matcher
  }
  tags = {
    Name = "${var.project_env}-${var.project_name}-app-tier-alb-tg-group"
  }
}

resource "aws_lb_listener" "app_tier_alb_listner_group" {
  provider          = aws.us-east
  load_balancer_arn = aws_lb.app_tier_alb.arn
  port              = var.alb_listner_http_port
  protocol          = var.alb_listner_http_protocol
  default_action {
    type             = var.alb_listner_action_type
    target_group_arn = aws_lb_target_group.app_tier_alb_tg_group.arn
  }
}

resource "aws_lb_target_group_attachment" "app_tier_alb_tg_group_attachment" {
  provider         = aws.us-east
  target_group_arn = aws_lb_target_group.app_tier_alb_tg_group.arn
  #target_id        = aws_instance.bastion_host_server.id
  target_id = aws_instance.app_server_subnet1_az1.id
  port      = var.alb_listner_http_port
}

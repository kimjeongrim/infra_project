# ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.private_subnets

  tags = {
    Name = "alb"
    Terraform = "true"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
  }

  tags = {
    Name = "alb-tg"
    Terraform = "true"
  }
}

resource "aws_lb_listener" "alb_li" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = "forward"
  }

  tags = {
    Name = "web-listener"
    Terraform = "true"
  }
}


resource "aws_lb_target_group_attachment" "alb_tgat" {
  count            = 2
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = element(aws_instance.workers.*.id, count.index)
  port             = 80
}



# NLB
resource "aws_lb" "k8_masters_lb" {
  name               = "nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = module.vpc.private_subnets #[for subnet in module.vpc.private_subnets : subnet.id]

  tags = {
    Name = "nlb"
    Terraform = "true"
  }

}

# target_type instance not working well when we bound this LB as a control-plane-endpoint. hence had to use IP target_type
#https://stackoverflow.com/questions/56768956/how-to-use-kubeadm-init-configuration-parameter-controlplaneendpoint/70799078#70799078

resource "aws_lb_target_group" "k8_masters_api" {
  name        = "k8-masters-api"
  port        = 6443
  protocol    = "TCP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    port                = 6443
    protocol            = "TCP"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "k8_masters_lb_listener" {
  load_balancer_arn = aws_lb.k8_masters_lb.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.k8_masters_api.id
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "k8_masters_attachment" {
  count            = length(aws_instance.masters.*.id)
  target_group_arn = aws_lb_target_group.k8_masters_api.arn
  target_id        = aws_instance.masters.*.private_ip[count.index]
}

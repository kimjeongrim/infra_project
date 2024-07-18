# 디폴트 보안 그룹
resource "aws_security_group" "default_sg" {
  name        = "default-sg"
  description = "default-ssh-imcp"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    },
    {
      description      = "icmp"
      from_port        = -1
      to_port          = -1
      protocol         = "icmp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = "all"
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = "default-sg"
  }
}

# ALB 보안그룹 (Master)
resource "aws_security_group" "alb_sg" {
  name = "alb_sg"
  description = "http-https"
  vpc_id = aws_vpc.vpc.id

  ingress = [
    {
      description      = "http"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    },
    {
      description      = "https"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    }
  ]

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}



# WEB 보안 그룹 (Worker)
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "http"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "http"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = [aws_security_group.alb_sg.id]
      self             = null
    },
    {
      description      = "https"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = [aws_security_group.alb_sg.id]
      self             = null
    }
  ]

  egress = [
    {
      description      = "all"
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]


  tags = {
    "Name" = "web-sg"
  }
}


# NLB 보안그룹
resource "aws_security_group" "nlb_sg" {
  name = "nlb_sg"
  description = "tomcat"
  vpc_id = aws_vpc.vpc.id

  ingress = [
    {
      description      = "tomcat"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = [aws_security_group.web_sg.id]
      prefix_list_ids  = null
      self             = null
    }
  ]

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nlb_sg"
  }
}


# WAS 보안 그룹
resource "aws_security_group" "was_sg" {
  name        = "was-sg"
  description = "http(tomcat)"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "http(tomcat)"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  =  [aws_security_group.nlb_sg.id]
      self             = null
    }
  ]

  egress = [
    {
      description      = "all"
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    "Name" = "was-sg"
  }
}

# DB 보안 그룹
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "mysql"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "mysql"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = [aws_security_group.was_sg.id]
      self             = null

    }
  ]

  egress = [
    {
      description      = "all"
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    "Name" = "db-sg"
  }
}


# Ansible 보안 그룹(Bastion) : 관리용
resource "aws_security_group" "ansible_sg" {
  name        = "ansible-sg"
  description = "ssh"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 관리자가 접속할 수 있도록 특정 IP로 제한
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

    tags = {
    "Name" = "ansible-sg"
  }
}

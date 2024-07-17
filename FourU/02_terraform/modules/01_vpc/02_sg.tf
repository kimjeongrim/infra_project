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

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "default-sg"
  }
}



# WEB 보안 그룹
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "http"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "all"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "http"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    "Name" = "web-sg"
  }
}


# WAS 보안그룹
resource "aws_security_group" "was_sg" {
  name        = "was-sg"
  description = "tomcat"
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
      security_groups  = [aws_security_group.default_sg.id, aws_security_group.web_sg.id]
      self             = null
    }
  ]

  egress {
    description      = "all"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    "Name" = "was-sg"
  }
}

# DB 보안 그룹
resource "aws_security_group" "ogurim_db_sg" {
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
      security_groups  = [aws_security_group.default_sg.id, aws_security_group.was_sg.id]
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

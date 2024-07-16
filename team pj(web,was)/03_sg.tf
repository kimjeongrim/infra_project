resource "aws_security_group" "foryou_sgweb" {
  name   = "web"
  vpc_id = aws_vpc.foryou-vpc.id

  ingress = [
    {
      description      = "${var.ssh}"
      from_port        = var.sshport
      to_port          = var.sshport
      protocol         = "${var.protcp}"
      cidr_blocks      = ["${var.dert}"]
      ipv6_cidr_blocks = ["${var.dert6}"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "${var.http}"
      from_port        = var.httpport
      to_port          = var.httpport
      protocol         = "${var.protcp}"
      cidr_blocks      = ["${var.dert}"]
      ipv6_cidr_blocks = ["${var.dert6}"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "${var.icmp}"
      from_port        = var.icmpport
      to_port          = var.icmpport
      protocol         = "${var.proicmp}"
      cidr_blocks      = ["${var.dert}"]
      ipv6_cidr_blocks = ["${var.dert6}"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = "all"
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = ["${var.dert}"]
      ipv6_cidr_blocks = ["${var.dert6}"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = "web"
  }
}
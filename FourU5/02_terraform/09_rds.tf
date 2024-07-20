resource "aws_instance" "database" {
  ami                         = "ami-04ea5b2d3c8ceccf8"
  instance_type               = var.db_instance_type
  availability_zone           = "ap-northeast-2a"
  private_ip                  = var.database_private_ip
  key_name                    = aws_key_pair.k8_ssh.key_name
  subnet_id                   = module.vpc.database_subnets[0]
  vpc_security_group_ids      = [aws_security_group.database.id]
  associate_public_ip_address = "true"
  user_data                   = file("user_data(db).sh")

  tags = {
    Name = "DB-01"
  }
}

# ami 센토스 변경
# user_data(db).sh 커스터마이징
# ssh -i  C:\3rd_project\FourU3\02_terraform\foryou_key.pem ubuntu@<EC2_PUBLIC_IP>

/*
resource "aws_network_acl_rule" "inbound_ssh" {
  network_acl_id = module.vpc.default_network_acl_id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "outbound_all" {
  network_acl_id = module.vpc.default_network_acl_id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}
*/
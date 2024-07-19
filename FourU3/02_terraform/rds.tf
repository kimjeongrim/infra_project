resource "aws_instance" "db_a" {
  ami                    = "ami-04ea5b2d3c8ceccf8"
  instance_type          = var.db_instance_type
  availability_zone      = "ap-northeast-2a"
  private_ip             = "10.0.4.11"
  key_name                = aws_key_pair.k8_ssh.key_name
  subnet_id              = module.vpc.database_subnets[0]
  vpc_security_group_ids = [aws_security_group.database.id]
  associate_public_ip_address = "true"
  user_data = file("user_data(db).sh")
 
  tags = {
    Name = "DB-01"
  }
}

# ami 센토스 변경
# sg 그룹 추가
# public ip 추가(bastion에서 통신가능!)
# user_data(db).sh 커스터마이징
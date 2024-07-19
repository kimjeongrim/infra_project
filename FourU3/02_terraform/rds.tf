resource "aws_instance" "db_a" {
  ami                    = data.aws_ami.amzn.id
  instance_type          = "t2.micro"
  key_name               = "ogurim"
  availability_zone      = "ap-northeast-2a"
  private_ip             = "10.0.5.11"
  subnet_id              = aws_subnet.dba.id
  vpc_security_group_ids = [aws_security_group.ogurim_sg.id]
  user_data = file("user_data(db).sh")

  depends_on = [aws_route_table_association.ogurim_nrtas_da]
 
  tags = {
    Name = "ogurim-dba"
  }
}

# ami 센토스 변경
# sg 그룹 추가
# public ip 추가
# user_data(db).sh 커스터마이징
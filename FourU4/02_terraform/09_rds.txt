resource "aws_db_instance" "foryou_db" {
  allocated_storage      = 20
  storage_type           = var.ssdtype
  engine                 = var.mysql
  engine_version         = var.engine_ver
  instance_class         = var.dbtype
  db_name                = var.db_name
  identifier             = "${var.name}-db"
  username               = var.username
  password               = var.password
  availability_zone      = "${var.region}c"
  db_subnet_group_name   = aws_db_subnet_group.foryou_dbsg.id
  vpc_security_group_ids = [aws_security_group.foryou_sg.id]
  skip_final_snapshot    = var.bool1
  #  multi_az                = true
  publicly_accessible     = true
  backup_retention_period = 3
  tags = {
    Name = "${var.name}-db"
  }
}

resource "aws_db_instance" "foryou_rep" {
  replicate_source_db = aws_db_instance.foryou_db.identifier
  auto_minor_version_upgrade = false
  backup_retention_period    = 3
  identifier                 = "${var.name}-rep"
  instance_class             = var.dbtype
  multi_az                   = false
  skip_final_snapshot        = true
  storage_encrypted          = true
  publicly_accessible        = true

  kms_key_id     = aws_db_instance.foryou_db.kms_key_id
  engine         = var.mysql
  engine_version = var.engine_ver
  vpc_security_group_ids = [aws_security_group.foryou_sg.id]
  password               = var.password
  
  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}

resource "aws_db_subnet_group" "foryou_dbsg" {
  name       = "${var.name}-dbsg"
  subnet_ids = concat(aws_subnet.foryou_db[*].id)
}

output "foryou_db" {
  value = aws_db_instance.foryou_db.endpoint
}
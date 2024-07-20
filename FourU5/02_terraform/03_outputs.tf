output "bastion_host_public_ip" {
  value = aws_instance.bastion.public_ip
}


output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}

output "masters_private_ip" {
  value = aws_instance.masters.*.private_ip
}

output "workers_private_ip" {
  value = aws_instance.workers.*.private_ip
}

output "db_private_ip" {
  value = aws_instance.database.*.private_ip
}

output "db_public_ip" {
  value = aws_instance.database.*.public_ip
}

output "alb_endpoint" {
  value = aws_lb_listener.alb_li.arn
}
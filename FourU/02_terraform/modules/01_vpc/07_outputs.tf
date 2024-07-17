output "vpc_id" {
  value       = aws_vpc.vpc.id
}

output "web_subnet_ids" {
  value = aws_subnet.web[*].id
}

output "was_subnet_ids" {
  value = aws_subnet.was[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db[*].id
}

output "eip_no" {
  value = aws_eip.foryou_eip.public_ip
}

# output "name_server" {
#   value = aws_route53_zone.foryou_rtz.name_servers
# }

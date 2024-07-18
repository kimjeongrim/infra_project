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

output "subnet_ids" {
  value = concat(aws_subnet.web[*].id, aws_subnet.was[*].id, aws_subnet.db[*].id)
}

output "eip_no" {
  value = aws_eip.foryou_eip.public_ip
}


output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "eks_role_arn" {
  value = aws_iam_role.eks_role.arn
}

output "node_group_role_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}

output "eks_role_name" {
  value = aws_iam_role.eks_role.name
}

output "eks_node_group_role_name" {
  value = aws_iam_role.eks_node_group_role.name
}
/*
output "web_instance_ids" {
  value = data.aws_autoscaling_group.web_worker_asg.instance_state[*].instance_id
}

output "was_instance_ids" {
  value = data.aws_autoscaling_group.was_worker_asg.instance_state[*].instance_id
}
*/

output "web_private_ips" {
  value = aws_eks_node_group.web_node_group.instances[*].private_ip
}

output "was_private_ips" {
  value = aws_eks_node_group.was_node_group.instances[*].private_ip
}
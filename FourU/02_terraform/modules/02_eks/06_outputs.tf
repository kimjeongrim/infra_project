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
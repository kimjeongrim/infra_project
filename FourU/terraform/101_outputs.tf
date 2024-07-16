output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "endpoint" {
  value = aws_eks_cluster.eks_clu.endpoint
}
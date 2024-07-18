resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids              = concat(aws_subnet.web[*].id, aws_subnet.was[*].id, aws_subnet.db[*].id)
    security_group_ids      = [aws_security_group.cluster_sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "web_node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.node_group_name}-web"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = aws_subnet.web[*].id
  capacity_type   = "ON_DEMAND"
  disk_size       = 20
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_node_group" "was_node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.node_group_name}-was"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = aws_subnet.was[*].id
  capacity_type   = "ON_DEMAND"
  disk_size       = 20
  instance_types  = [var.instance_type]
  
  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly,
  ]
}

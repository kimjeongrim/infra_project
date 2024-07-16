resource "aws_eks_cluster" "eks_clu" {
  name     = "${var.name}-clu"
  role_arn = aws_iam_role.eks_clurole.arn

  vpc_config {
    subnet_ids              = concat(aws_subnet.subnet_mas[*].id, aws_subnet.subnet_work[*].id)
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids = [aws_security_group.eks_cluster.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}


/*
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_clurole" {
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
*/

resource "aws_iam_role" "eks_clurole" {
  name = "terraform-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_clurole.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_clurole.name
}

resource "aws_eks_addon" "eks_coredns" {
  cluster_name                = aws_eks_cluster.eks_clu.name
  addon_name                  = "coredns"
  addon_version               = "v1.11.1-eksbuild.8"
 resolve_conflicts_on_create = "OVERWRITE"
 }

resource "aws_eks_addon" "eks_cni" {
  cluster_name                = aws_eks_cluster.eks_clu.name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.18.2-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
}

resource "aws_eks_addon" "eks_pod" {
  cluster_name                = aws_eks_cluster.eks_clu.name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = "v1.3.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
}

resource "aws_eks_addon" "eks_proxy" {
  cluster_name                = aws_eks_cluster.eks_clu.name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.30.0-eksbuild.3"
  resolve_conflicts_on_create = "OVERWRITE"
}

resource "aws_security_group" "eks_sg" {
  name        = "eks-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster"
  }
}

# security group의 ingress 룰을 추가한다.
resource "aws_security_group_rule" "eks-cluster-ingress-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  to_port           = 443
  type              = "ingress"
}

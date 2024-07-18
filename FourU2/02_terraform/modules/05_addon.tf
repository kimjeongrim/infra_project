# resource "aws_eks_addon" "eks_coredns" {
#   cluster_name                = aws_eks_cluster.eks_clu.name
#   addon_name                  = "coredns"
#   addon_version               = "v1.11.1-eksbuild.8"
#  resolve_conflicts_on_create = "OVERWRITE"
#  }

# resource "aws_eks_addon" "eks_cni" {
#   cluster_name                = aws_eks_cluster.eks_clu.name
#   addon_name                  = "vpc-cni"
#   addon_version               = "v1.18.2-eksbuild.1"
#   resolve_conflicts_on_create = "OVERWRITE"
# }

# resource "aws_eks_addon" "eks_pod" {
#   cluster_name                = aws_eks_cluster.eks_clu.name
#   addon_name                  = "eks-pod-identity-agent"
#   addon_version               = "v1.3.0-eksbuild.1"
#   resolve_conflicts_on_create = "OVERWRITE"
# }

# resource "aws_eks_addon" "eks_proxy" {
#   cluster_name                = aws_eks_cluster.eks_clu.name
#   addon_name                  = "kube-proxy"
#   addon_version               = "v1.30.0-eksbuild.3"
#   resolve_conflicts_on_create = "OVERWRITE"
# }

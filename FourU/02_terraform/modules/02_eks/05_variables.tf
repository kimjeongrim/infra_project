variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}


variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}


variable "eks_role_name" {
  description = "Name of the EKS IAM role"
  type        = string
}

variable "eks_node_group_role_name" {
  description = "Name of the EKS Node Group IAM role"
  type        = string
}
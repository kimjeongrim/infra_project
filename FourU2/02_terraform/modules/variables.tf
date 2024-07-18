variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "web_subnet_cidrs" {
  description = "List of CIDR blocks for Web subnets"
  type        = list(string)
}

variable "was_subnet_cidrs" {
  description = "List of CIDR blocks for WAS subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "List of CIDR blocks for DB subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "web_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "was_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "instance_type" {
  description = "List of subnet IDs for the EKS cluster"
  type        = string
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



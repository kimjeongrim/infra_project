variable "name" {
  description = "The name of the VPC"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS Cluster"
  type        = string
}


variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "web_subnet_cidrs" {
  description = "Public Web subnet CIDR blocks"
  type        = list(string)
}

variable "was_subnet_cidrs" {
  description = "Private Was subnet CIDR blocks"
  type        = list(string)
}


# variable "mas_subnet_cidrs" {
#   description = "Private EKS Master subnet CIDR blocks"
#   type        = list(string)
# }

variable "db_subnet_cidrs" {
  description = "Private DB subnet CIDR blocks"
  type        = list(string)
}
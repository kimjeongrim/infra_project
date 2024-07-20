variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "name" {
  type    = string
  default = "foryou"
}

# ubuntu 24.04 LTS AMI
variable "ami_id" {
  type    = string
  default = "ami-062cf18d655c0b1e8"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "db_subnets" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "master_node_count" {
  type    = number
  default = 2
}

variable "worker_node_count" {
  type    = number
  default = 4
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "master_instance_type" {
  type    = string
  default = "t2.large"
}

variable "worker_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "db_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "bastion_instance_type" {
  type    = string
  default = "t2.large"
}

variable "route53" {
  type    = string
  default = "ogurim.store"
}

variable "route_type" {
  type    = string
  default = "A"
}

variable "route53_www" {
  type    = string
  default = "www.ogurim.store"
}

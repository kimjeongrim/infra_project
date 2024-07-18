module "foryou_vpc" {
  source             = "./modules"
  name               = "foryou"
  availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
  vpc_cidr           = "10.0.0.0/16"
  web_subnet_cidrs   = ["10.0.0.0/24", "10.0.1.0/24"]
  was_subnet_cidrs   = ["10.0.2.0/24", "10.0.3.0/24"]
  db_subnet_cidrs    = ["10.0.4.0/24", "10.0.5.0/24"]
  web_subnet_ids           = ["10.0.0.0/24", "10.0.1.0/24"]
  was_subnet_ids           = ["10.0.2.0/24", "10.0.3.0/24"]
  cluster_name       = "eks-cluster"
  node_group_name          = "eks-node-group"
  subnet_ids               =  ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  instance_type            = "t3.medium"
  desired_capacity         = 2
  max_size                 = 3
  min_size                 = 1
  eks_role_name            = "eks-cluster-role"
  eks_node_group_role_name = "eks-node-group-role"

}


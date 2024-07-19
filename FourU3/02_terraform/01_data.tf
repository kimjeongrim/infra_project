module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "foryou"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  database_subnets = var.db_subnets
  create_multiple_public_route_tables = true
 # public_subnet_tags = map(string)
 # private_subnet_tags = map(string)
  enable_nat_gateway = true
  single_nat_gateway = true
  create_igw = true
  map_public_ip_on_launch = true
#  enable_dns_hostnames = true
#  enable_dns_support = true
#  public_subnet_enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Terraform = "true"
  }
}
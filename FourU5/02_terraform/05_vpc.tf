resource "aws_route_table_association" "igw_rtas" {
  count          = length(module.vpc.public_subnets)
  subnet_id      = element(module.vpc.public_subnets, count.index)
  route_table_id = element(module.vpc.public_route_table_ids, 0)
}

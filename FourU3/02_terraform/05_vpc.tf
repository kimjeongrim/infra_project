resource "aws_route_table_association" "public_rtas" {
  count = 2
  subnet_id      =  aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
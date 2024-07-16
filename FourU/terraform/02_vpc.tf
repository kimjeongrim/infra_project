resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                                = "${var.name}-vpc"
    "kubernetes.io/cluster/${var.name}" = "shared"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-ig"
  }
}

resource "aws_subnet" "subnet_mas" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2${count.index == 0 ? "a" : "c"}"

  tags = {
    Name = "${var.name}-pub-${count.index == 0 ? "a" : "c"}"
    "kubernetes.io/cluster/${var.name}" = "shared"
  }
}

resource "aws_subnet" "subnet_work" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${count.index + 2}.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-2${count.index + 2 == 2 ? "a" : "c"}"

  tags = {
    Name = "${var.name}-pri-${count.index + 2 == 0 ? "a" : "c"}"
    "kubernetes.io/cluster/${var.name}" = "shared"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "${var.name}-rt"
  }
}

resource "aws_route_table_association" "rtas1" {
  count = 2
  subnet_id      = aws_subnet.subnet_mas[count.index].id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rtas2" {
  count = 2
  subnet_id      = aws_subnet.subnet_work[count.index].id
  route_table_id = aws_route_table.rt.id
}

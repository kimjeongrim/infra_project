# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

# Subnet
resource "aws_subnet" "web" {
  count                   = length(var.web_subnet_cidrs)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name                                = "${var.name}-web-pub-${count.index == 0 ? "a" : "c"}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "was" {
  count             = length(var.was_subnet_cidrs)
  
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.was_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name                                = "${var.name}-was-pri-${count.index + 2 == 2 ? "a" : "c"}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}


resource "aws_subnet" "db" {
  count             = length(var.db_subnet_cidrs)
  
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name = "${var.name}-db-pri-${count.index == 0 ? "a" : "c"}"

  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
   vpc_id = aws_vpc.vpc.id
   
   tags = {
		Name = "${var.name}-ig"
	}
}

resource "aws_route_table" "route_table" {
	vpc_id = aws_vpc.vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.internet_gateway.id
	}

   tags = {
		Name = "${var.name}-rt"
	}
}

resource "aws_route_table_association" "rtas_web" {
  count = 2
  subnet_id      =  aws_subnet.web[count.index].id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_eip" "foryou_eip" {
  domain = "vpc"
}

# Nat Gateway
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.web[0].id
  allocation_id = aws_eip.foryou_eip.id
  private_ip    = "10.0.0.11"
  
  depends_on = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "${var.name}-ngw"
  }
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.name}-nrt"
  }
}

resource "aws_route_table_association" "nrtas_was" {
  count             = length(var.was_subnet_cidrs)
  subnet_id      = aws_subnet.was[count.index].id
  route_table_id = aws_route_table.nat_route_table.id
}

resource "aws_route_table_association" "nrtas_db" {
  count             = length(var.db_subnet_cidrs)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.nat_route_table.id

   lifecycle {
    ignore_changes = [subnet_id] # 이미 연결된 서브넷은 변경을 무시합니다.
  }

}

/*
# internal Route Table
resource "aws_route_table" "internal_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-internal-rt"
  }
}

#resource "aws_route_table_association" "in_rtas_web" {
   count             = length(var.was_subnet_cidrs)
   subnet_id      = aws_subnet.was[count.index].id
   route_table_id = aws_route_table.internal_route_table.id
 }

resource "aws_route_table_association" "in_rtas_was" {
  count             = length(var.was_subnet_cidrs)
  subnet_id      = aws_subnet.was[count.index].id
  route_table_id = aws_route_table.internal_route_table.id
}

resource "aws_route_table_association" "in_rtas_db" {
  count             = length(var.db_subnet_cidrs)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.internal_route_table.id
}

*/
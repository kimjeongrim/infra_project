resource "aws_vpc" "foryou-vpc" {
  cidr_block           = var.cidr
  instance_tenancy     = var.tenancy
  enable_dns_hostnames = var.bool1
  enable_dns_support   = var.bool1

  tags = {
    Name                                = "${var.name}-vpc"
    "kubernetes.io/cluster/${var.name}" = "shared"
  }
}

resource "aws_internet_gateway" "foryou-ig" {
  vpc_id = aws_vpc.foryou-vpc.id

  tags = {
    Name = "${var.name}-ig"
  }
}

resource "aws_subnet" "web" {
  count                   = 2
  vpc_id                  = aws_vpc.foryou-vpc.id
  cidr_block              = "${var.subip}${count.index}.0/24"
  map_public_ip_on_launch = var.bool1
  availability_zone       = "${var.region}${count.index == 0 ? "a" : "c"}"

  tags = {
    Name                                = "${var.name}-web-pub-${count.index == 0 ? "a" : "c"}"
    "kubernetes.io/cluster/${var.name}" = "shared"
  }
}

resource "aws_subnet" "was" {
  count                   = 2
  vpc_id                  = aws_vpc.foryou-vpc.id
  cidr_block              = "10.0.${count.index + 2}.0/24"
  map_public_ip_on_launch = var.bool1
  availability_zone       = "${var.region}${count.index == 0 ? "a" : "c"}"

  tags = {
    Name                                = "${var.name}-was-pri-${count.index + 2 == 2 ? "a" : "c"}"
    "kubernetes.io/cluster/${var.name}" = "shared"
  }
}

resource "aws_subnet" "db" {
  count =2
  vpc_id                  = aws_vpc.foryou-vpc.id
  cidr_block              = "${var.subip}${count.index + 4}.0/24"
  availability_zone       = "${var.region}${count.index == 0 ? "a" : "c"}"
  map_public_ip_on_launch = var.bool1

  tags = {
    Name                                = "${var.name}-db-pri-${count.index == 0 ? "a" : "c"}"
    "kubernetes.io/cluster/${var.name}" = "shared"
  }
}

resource "aws_eip" "foryou_eip" {
  domain = "vpc"
}

output "eip_no" {
  value = aws_eip.foryou_eip.public_ip
}

resource "aws_route_table" "foryou_rt" {
  vpc_id = aws_vpc.foryou-vpc.id

  route {
    cidr_block = "${var.dert}"
    gateway_id = aws_internet_gateway.foryou-ig.id
  }

  tags = {
    Name = "${var.name}-rt"
  }
}

resource "aws_route_table_association" "foryou_rtas" {
  count = 2
  subnet_id      = aws_subnet.web[count.index].id
  route_table_id = aws_route_table.foryou_rt.id
}


resource "aws_nat_gateway" "foryou_nigw" {
  allocation_id = aws_eip.foryou_eip.id
  subnet_id     = aws_subnet.web[0].id
  private_ip    = "${var.pri}"

  depends_on = [aws_internet_gateway.foryou-ig]

  tags = {
    Name = "${var.name}-nigw"
  }
}

resource "aws_route_table" "foryou_nrt" {
  vpc_id = aws_vpc.foryou-vpc.id

  route {
    cidr_block = var.dert
    gateway_id = aws_nat_gateway.foryou_nigw.id
  }

  tags = {
    Name = "${var.name}-nrt"
  }
}

resource "aws_route_table_association" "cyi_nrtas_wa" {
  count = 2
  subnet_id      = aws_subnet.was[count.index].id
  route_table_id = aws_route_table.foryou_nrt.id
}

resource "aws_route_table_association" "cyi_nrtas_da" {
  count = 2
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.foryou_nrt.id
}

resource "aws_route53_zone" "foryou_rtz" {
  name          = "${var.route53}"
  force_destroy = var.bool1
}

resource "aws_route53_record" "domain" {
  zone_id = aws_route53_zone.foryou_rtz.id
  name    = "${var.route53}"
  type    = "${var.route_type}"

  alias {
    name                   = aws_lb.foryou_web_lb.dns_name
    zone_id                = aws_lb.foryou_web_lb.zone_id
    evaluate_target_health = var.bool1
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.foryou_rtz.id
  name    = "${var.route53_www}"
  type    = "${var.route_type}"

  alias {
    name                   = aws_lb.foryou_web_lb.dns_name
    zone_id                = aws_lb.foryou_web_lb.zone_id
    evaluate_target_health = var.bool1
  }
}

output "name_server" {
  value = aws_route53_zone.foryou_rtz.name_servers
}


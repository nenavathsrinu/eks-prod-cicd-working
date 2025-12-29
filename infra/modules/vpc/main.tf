resource "aws_vpc" "lsg_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
    Name = "${var.cluster_name}-vpc"
  }
  )
}

resource "aws_internet_gateway" "lsg_igw" {
  vpc_id = aws_vpc.lsg_vpc.id

  tags = merge(
    var.tags,
    {
    Name = "${var.cluster_name}-igw"
  }
  )
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.lsg_vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
    Name = "${var.cluster_name}-public-subnet-${count.index}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  )
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.lsg_vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.tags,
    {
    Name = "${var.cluster_name}-private-subnet-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  )
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lsg_vpc.id

  tags = merge(
    var.tags,
    {
    Name = "${var.cluster_name}-public-rt"
    }
  )
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lsg_igw.id
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "lasg_nat_eip" {
    domain = "vpc"
    tags = merge(
      var.tags,
      {
        Name = "${var.cluster_name}-nat-eip"
      }
    )
}

resource "aws_nat_gateway" "lasg_nat_gw" {
    allocation_id = aws_eip.lasg_nat_eip.id
    subnet_id     = aws_subnet.public_subnets[0].id

    tags = merge(
      var.tags,
      {
        Name = "${var.cluster_name}-nat-gw"
      }
    )
    }

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.lsg_vpc.id

  tags = merge(
    var.tags,
    {
    Name = "${var.cluster_name}-private-rt"
  }
  )
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.lasg_nat_gw.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
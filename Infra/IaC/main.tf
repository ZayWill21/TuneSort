provider "aws" {
  region = var.region
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  
  tags = {
    Name = "${var.stack_name}"
  }
}

data "aws_availability_zones" "available" {}

data "aws_partition" "current" {}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-vpc"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-ig"
    }
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-public-route-table"
    }
  )
}

# Route to Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Public Subnets
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_block1
  availability_zone       = local.azs[0]
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-public-subnet1"
      "kubernetes.io/role/elb" = "1"
    }
  )
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_block2
  availability_zone       = local.azs[1]
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-public-subnet2"
      "kubernetes.io/role/elb" = "1"
    }
  )
}

resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_block3
  availability_zone       = local.azs[2]
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-public-subnet3"
      "kubernetes.io/role/elb" = "1"
    }
  )
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat1" {
  domain = "vpc"
  
  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-eip1"
    }
  )
}

resource "aws_eip" "nat2" {
  domain = "vpc"
  
  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-eip2"
    }
  )
}

resource "aws_eip" "nat3" {
  domain = "vpc"
  
  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-eip3"
    }
  )
}

# NAT Gateways
resource "aws_nat_gateway" "nat_gw1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public1.id

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-nat-gw1"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public2.id

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-nat-gw2"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw3" {
  allocation_id = aws_eip.nat3.id
  subnet_id     = aws_subnet.public3.id

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-nat-gw3"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

# Private Subnets
resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_cidr_block1
  availability_zone       = local.azs[0]
  map_public_ip_on_launch = false

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-private-subnet1"
    }
  )
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_cidr_block2
  availability_zone       = local.azs[1]
  map_public_ip_on_launch = false

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-private-subnet2"
    }
  )
}

resource "aws_subnet" "private3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_cidr_block3
  availability_zone       = local.azs[2]
  map_public_ip_on_launch = false

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-private-subnet3"
    }
  )
}

# Private Route Tables
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-private-route-table1"
    }
  )
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-private-route-table2"
    }
  )
}

resource "aws_route_table" "private3" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.tags,
    {
      Name = "${var.stack_name}-private-route-table3"
    }
  )
}

# Private Routes to NAT Gateways
resource "aws_route" "private1" {
  route_table_id         = aws_route_table.private1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw1.id
}

resource "aws_route" "private2" {
  route_table_id         = aws_route_table.private2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw2.id
}

resource "aws_route" "private3" {
  route_table_id         = aws_route_table.private3.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw3.id
}

# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private3.id
}

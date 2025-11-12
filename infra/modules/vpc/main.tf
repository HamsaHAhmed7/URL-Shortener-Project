resource "aws_vpc" "url_shortener_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "url-shortener-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.url_shortener_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "url-shortener-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.url_shortener_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "url-shortener-public-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.url_shortener_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "url-shortener-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.url_shortener_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "url-shortener-private-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.url_shortener_vpc.id
  tags = {
    Name = "url-shortener-igw"
  }
}

# REMOVED - Using VPC Endpoints instead
# resource "aws_eip" "nat_eip" {
#   domain = "vpc"
#   tags = {
#     Name = "url-shortener-nat-eip"
#   }
# }

# resource "aws_nat_gateway" "url_nat_gw" {
#   subnet_id     = aws_subnet.public_subnet_1.id
#   allocation_id = aws_eip.nat_eip.id
#   depends_on    = [aws_internet_gateway.igw]
#   tags = {
#     Name = "url-shortener-nat-gw"
#   }
# }

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.url_shortener_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "url-shortener-public-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Private route table - no NAT route, using VPC endpoints
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.url_shortener_vpc.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.url_nat_gw.id
  # }

  tags = {
    Name = "url-shortener-private-rt"
  }
}

resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_vpc" "lab-vpc1" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.lab-vpc1.id
  cidr_block = var.cidr_public

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table" "internet_route_table" {
  vpc_id = aws_vpc.lab-vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.lab-vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_GW.id

  }

  tags = {
    Name = "nat_gateway"
  }
}

resource "aws_route_table_association" "Public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.internet_route_table.id
}


resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.lab-vpc1.id

  tags = {
    Name = "IGW"
  }
}



resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "NAT_GW"
  }
  depends_on = [aws_internet_gateway.IGW]
}
resource "aws_subnet" "public" {
  vpc_id            = var.vpc_id
  cidr_block        = var.public_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.name}-public-route-table"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.gateway_id
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-route-table.id
}


resource "aws_subnet" "private" {
  vpc_id     = var.vpc_id
  cidr_block = var.private_cidr

  tags = {
    Name = "${var.name}-private-subnet"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-private-route-table"
  }
}

resource "aws_eip" "nat_gateway" {

  tags = {
    Name = "${var.name}-nat-eip"
  }
}

resource "aws_nat_gateway" "my-ngw" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${var.name}-nat-gateway"
  }

  depends_on = [aws_eip.nat_gateway]
}

resource "aws_route" "nat-ngw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.my-ngw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private.id
}




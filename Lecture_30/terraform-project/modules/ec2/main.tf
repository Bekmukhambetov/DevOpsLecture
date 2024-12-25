resource "aws_instance" "public" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "${var.name}-public-instance"
  }
}

resource "aws_instance" "private" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id

  tags = {
    Name = "${var.name}-private-instance"
  }
}

resource "aws_instance" "imported_instance" {
  ami           = "ami-01816d07b1128cd2d"
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "new_instans"
  }
}
# Exercici 1 Pt1-4

Indiquem proveïdor
```
provider "aws" {
  region = "us-east-1"
}
```
Creem VPC-03 en la red 10.0.0.0/16
```
resource "aws_vpc" "vpc_03" {
  cidr_block           = "10.0.0.0/16"  
  tags = {
    Name = "VPC-03"
  }
}
```
Creem recursos de tipus *subnet*
```
resource "aws_subnet" "p_subnet_a" {
  vpc_id                  = aws_vpc.vpc_03.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet-A"
  }
}
resource "aws_subnet" "p_subnet_b" {
  vpc_id                  = aws_vpc.vpc_03.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet-B"
  }
}
```
Creem Internet Gateway i Taula de Rutes
```
# Gateway a internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_03.id
  tags = {
    Name = "Gateway-VPC-03"
  }
}
# Taula de rutes
resource "aws_route_table" "p_rt" {
  vpc_id = aws_vpc.vpc_03.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public-Route-Table"
  }
}
resource "aws_route_table_association" "p_rt_as_a" {
  subnet_id      = aws_subnet.p_subnet_a.id
  route_table_id = aws_route_table.p_rt.id
}

resource "aws_route_table_association" "p_rt_as_b" {
  subnet_id      = aws_subnet.p_subnet_b.id
  route_table_id = aws_route_table.p_rt.id
}
```
Creem Grup de Seguretat amb les regles corresponents:
```
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Grup de seguretat per a EC2"
  vpc_id      = aws_vpc.vpc_03.id
  # Permet connexions SSH des de qualsevol lloc
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acces SSH"
  }
  # Permet ping només dins la VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "ICMP dins la VPC"
  }
  # Permet tot el transit que surt
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permet tot el transit sortint"
  }
  tags = {
    Name = "EC2-Security-Group"
  }
}
```
Creem instàncies EC2:
```
# Instàncies EC2
resource "aws_instance" "ec2_a" {
  ami                    = "ami-0c02fb55956c7d316"  # Amazon Linux 2023
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.p_subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "vockey"
  tags = {
    Name = "ec2-a"
  }
}
resource "aws_instance" "ec2_b" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.p_subnet_b.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "vockey"
  tags = {
    Name = "ec2-b"
  }
}
```
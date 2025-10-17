# Exercici 2
Creació d'instàncies a dins d'una VPC (Virtual Private Cloud) segmentades per Subnets.

Indiquem proveïdor
```
provider "aws" {
  region = "us-east-1"
}
```
Creem VPC en la red 10.0.0.0/16
```
resource "aws_vpc" "main_vpc" {
    cidr_block  = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "Cristian-VPC"
    }
}
```
Creem recursos de tipus *subnet*
```
resource "aws_subnet" "subnetA" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.32.0/25"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetA"
  }
}
resource "aws_subnet" "subnetB" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.30.0/23"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetB"
  }
}
resource "aws_subnet" "subnetC" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.33.0/28"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetC"
  }
}
```
Creem recursos de tipus instància en cada subnet (subnet_id)
```
# Subnet A
resource "aws_instance" "instancias_subnetA" {
  count = 2
  ami = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.subnetA.id
  tags = {
    # Esto para que se vayan haciendo de forma enumerada.
    Name = "SubnetA-Instance-${count.index + 1}"
  }
}
# Subnet B
resource "aws_instance" "instancias_subnetB" {
  count = 2
  ami = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.subnetB.id
  tags = {
    # Esto para que se vayan haciendo de forma enumerada.
    Name = "SubnetB-Instance-${count.index + 1}"
  }
}
# Subnet C
resource "aws_instance" "instancias_subnetC" {
  count = 2
  ami = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.subnetC.id
  tags = {
    # Esto para que se vayan haciendo de forma enumerada.
    Name = "SubnetC-Instance-${count.index + 1}"
  }
}
```
Apply de terraform:
![alt text](<../pt1-3-ex1/assets/images/Captura de pantalla 2025-10-17 214912.png>)
### Fet desde la GUI
![alt text](../pt1-3-ex1/assets/images/AWS.png) 
### Topologia a Lucid:
![alt text](<assets/images/Marco horizontal AWS (2019).png>)

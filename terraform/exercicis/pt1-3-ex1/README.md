# Exercici 1
Creació de dues instàncies t3.micro a AWS via Terraform.

``` 
# main.tf
# Indicamos el proveedor
provider "aws" {
  region = "us-east-1"
}

# Creamos las instancias, las dos a la vez
resource "aws_instance" "instancias-ex1" {
  count         = 2
  ami           = "ami-052064a798f08f0d3"
  instance_type = "t3.micro"
  tags = {
    Name = "Instancia-Terraform-${count.index + 1}"
  }
}
```
Després apliquem amb `$terraform plan` i `$terraform apply`
## Topología a Lucid:
![alt text](<assets/images/Marco vertical AWS (2019) (1).png>)
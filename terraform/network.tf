### Criação de Internet Nat Gateway
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-igw"
  }
}

### Criação de rota customizadas para subnets públicas
resource "aws_route_table" "prod-public-crt" {
    vpc_id = aws_vpc.prod-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prod-igw.id
    }

    tags = {
        Name = "prod-public-crt"
    }
}

### Associar rota para subnets públicas
resource "aws_route_table_association" "prod-crta-public-subnet-1" {
    subnet_id = aws_subnet.prod-subnet-public-1.id
    route_table_id = aws_route_table.prod-public-crt.id
}
resource "aws_route_table_association" "prod-crta-public-subnet-2" {
    subnet_id = aws_subnet.prod-subnet-public-2.id
    route_table_id = aws_route_table.prod-public-crt.id
}
resource "aws_route_table_association" "prod-crta-public-subnet-3" {
    subnet_id = aws_subnet.prod-subnet-public-3.id
    route_table_id = aws_route_table.prod-public-crt.id
}

### Criação de Elastic IP para NAT Gateway
resource "aws_eip" "nat" {
vpc      = true
    tags = {
        Name = "prod-elastic-ip-crt"
    }
}

### Criação de NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
allocation_id = aws_eip.nat.id
subnet_id = aws_subnet.prod-subnet-public-1.id
depends_on = [aws_internet_gateway.prod-igw]
    tags = {
        Name = "prod-nat-gateway-crt"
    }
}

### Criação de rotas customizadas para subnets privadas
resource "aws_route_table" "prod-private-crt" {
    vpc_id = aws_vpc.prod-vpc.id
    route {
        cidr_block = "0.0.0.0/0" //associated subnet can reach everywhere
        nat_gateway_id = aws_nat_gateway.nat-gw.id
    }

    tags = {
        Name = "prod-private-crt"
    }
}

### Associar rota para subnets privadas
resource "aws_route_table_association" "private-1" {
    subnet_id = aws_subnet.prod-subnet-private-1.id
    route_table_id = aws_route_table.prod-private-crt.id
}


### Security Groups

### SG para Webservers - subnet pública
resource "aws_security_group" "webservers" {
  name        = "webservers"
  description = "Allow webservers"
    vpc_id = aws_vpc.prod-vpc.id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
    
  }


}


### SG para DBservers - Subnet privada
resource "aws_security_group" "dbservers" {
  name        = "dbservers"
  description = "Allow dbservers"
    vpc_id = aws_vpc.prod-vpc.id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["10.0.0.0/16"]
    
  }

}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "Terraform-vpc" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "main-igw" }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone_1a
  tags = { Name = "public-subnet" }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone_1b
  tags = { Name = "private-subnet" }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.ssh_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-route-table" }
}

# Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id
  name   = "jenkins-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Prometheus EC2
resource "aws_instance" "Prometheus" {
  ami                    = var.ami
  instance_type          = var.instance_type_prometheus
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = true
  key_name = var.key_name
  user_data = file("Prometheus.sh")
  tags = { Name = "Prometheus-VM" }
}

# Grafana EC2
resource "aws_instance" "Grafana" {
ami                    = var.ami
 instance_type          = var.instance_type_grafana
 subnet_id              = aws_subnet.public.id
 vpc_security_group_ids = [aws_security_group.sg.id]
 associate_public_ip_address = true
 key_name = var.key_name
 user_data = file("Grafana.sh")
 tags = { Name = "Grafana-VM" }
}

# Nginx EC2
resource "aws_instance" "Nginx-Server" {
ami                    = var.ami
 instance_type          = var.Nginx
 subnet_id              = aws_subnet.public.id
 vpc_security_group_ids = [aws_security_group.sg.id]
 associate_public_ip_address = true
 key_name = var.key_name
 user_data = file("setup-nginx-node.sh")
 tags = { Name = "Nginx-Node-VM" }
}


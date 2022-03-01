terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "Project 1 VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Project 1 Internet Gateway"
  }
}

resource "aws_eip" "main" {
  vpc      = true
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.private.id
  connectivity_type = "public"
  tags = {
    Name = "Public NAT"
  }
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}



data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "description"
    values = ["Amazon Linux AMI 2.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"] # AWS
}

output "ami_name" {
  value = data.aws_ami.amazon_linux
}

resource "aws_security_group" "app_server" {
  name        = "app_server"
  description = "Allow 80, 443, 22, 8065 inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "Allow Ports on app_server"
  }
}

resource "aws_security_group_rule" "app_server" {
  count = length(var.aws_security_group_app_server)

  type              = "ingress"
  from_port         = var.aws_security_group_app_server[count.index].from_port
  to_port           = var.aws_security_group_app_server[count.index].to_port
  protocol          = var.aws_security_group_app_server[count.index].protocol
  cidr_blocks       = ["0.0.0.0/0"]
  description       = var.aws_security_group_app_server[count.index].description
  security_group_id = aws_security_group.app_server.id
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.app_server.id]
  tags = {
    Name = "Application Server"
  }
  depends_on = [aws_security_group.app_server]
}



resource "aws_security_group" "db_server" {
  name        = "app_server"
  description = "Allow 80, 443, 22, 3306 inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "Allow Ports on db_server"
  }
}

resource "aws_security_group_rule" "db_server" {
  count = length(var.aws_security_group_db_server)

  type              = "ingress"
  from_port         = var.aws_security_group_db_server[count.index].from_port
  to_port           = var.aws_security_group_db_server[count.index].to_port
  protocol          = var.aws_security_group_db_server[count.index].protocol
  cidr_blocks       = ["0.0.0.0/0"]
  description       = var.aws_security_group_db_server[count.index].description
  security_group_id = aws_security_group.db_server.id
}

resource "aws_instance" "db_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private.id
  security_groups = [aws_security_group.db_server.id]
  tags = {
    Name = "Application Server"
  }
  depends_on = [aws_security_group.db_server]
}

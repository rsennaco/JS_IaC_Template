# VPC config
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "main-vpc"
    }
}

# Subnet config
resource "aws_subnet" "public" {
    vpc_id = "aws_vpc.main.id"
    cidr_block = var.subnet_cidr
    availability_zone = var.az

    tags = {
        Name = "public-subnet"
    }
}

# IG config
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "main-igw"
    }
}

# Route Table config
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = var.route_cidr
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "public-route-table"
    }
}

# Route Table Association config
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}
#VPC creation 
resource "aws_vpc" "labVPC" {
    cidr_block       = var.lab_cidr
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags = {
        Name = var.lab_tag
        project = var.project
  }
}

##Subnets
#public Subnet

resource "aws_subnet" "lab_public_subnet" {
    vpc_id = aws_vpc.labVPC.id
    cidr_block = var.lab_public_subnet

    tags = {
        Name = "Lab Public Subnet"
        project = var.project
    }
}

#Private Subnet
resource "aws_subnet" "lab_private_subnet" {
    vpc_id = aws_vpc.labVPC.id
    cidr_block = var.lab_private_subnet

    tags = {
        Name = "Lab Private Subnet"
        project = var.project
    }
}

#Internet Gateway
resource "aws_internet_gateway" "lab_IGW" {
    vpc_id = aws_vpc.labVPC.id

    tags = {
        Name = "lab_IGW" 
        project = var.project
    }
}

#Elastic IP
resource "aws_eip" "NGW-eip" {
    vpc = true 
    
    tags = {
        Name = "lab_eip" 
        project = var.project
    }
}

#Nat Gateway

resource "aws_nat_gateway" "lab_NGW" {
    allocation_id = aws_eip.NGW-eip.id
    subnet_id     = aws_subnet.lab_public_subnet.id
    depends_on = [aws_internet_gateway.lab_IGW]
    

    tags = {
        Name = "lab_NGW" 
        project = var.project
    }
}
##Route Tables 

#public Route_table
resource "aws_route_table" "lab_public_RT" {
    vpc_id = aws_vpc.labVPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lab_IGW.id
    }

    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.lab_IGW.id
    }

    tags = {
        Name = "Lab Public Route Table" 
        project = var.project
    }
}


#private Route Table
resource "aws_route_table" "lab_private_RT" {
    vpc_id = aws_vpc.labVPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.lab_NGW.id
    }


    tags = {
        Name = "Lab Private Route Table" 
        project = var.project
    }
}

##Subnet assosications

#public

resource "aws_route_table_association" "lab_public_rt_assosc" {
  subnet_id  = aws_subnet.lab_public_subnet.id
  route_table_id = aws_route_table.lab_public_RT.id
}

#private
resource "aws_route_table_association" "lab_private_rt_assosc" {
  subnet_id  = aws_subnet.lab_private_subnet.id
  route_table_id = aws_route_table.lab_private_RT.id
}


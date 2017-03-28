# Internet VPC

data "aws_caller_identity" "current" {}

resource "aws_vpc" "VPC-TF-Ansible-ELK"{
    cidr_block = "10.100.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "VPC-TF-Ansible-ELK"
        AccountID = "${data.aws_caller_identity.current.account_id}"
    }
}

# Subnets
resource "aws_subnet" "Subnet-Public-TF-Ansible-ELK" {
    vpc_id = "${aws_vpc.VPC-TF-Ansible-ELK.id}"
    cidr_block = "10.100.1.0/24"
    map_public_ip_on_launch = "true"
    tags {
        Name = "Subnet-Public-TF-Ansible-ELK"
        AccountID = "${data.aws_caller_identity.current.account_id}"
    }
}

# Internet Gateway

resource "aws_internet_gateway" "IGW-TF-Ansible-ELK" {
    vpc_id = "${aws_vpc.VPC-TF-Ansible-ELK.id}"
    tags {
        Name = "IGW-TF-Ansible-ELK"
        AccountID = "${data.aws_caller_identity.current.account_id}"
    }
}


# NAT GW

resource "aws_eip" "NAT-EIP-TF-Ansible-ELK" {
  vpc      = true
#  tags {
#    Name = "NAT-EIP-TF-Ansible-ELK"
#    AccountID = "${data.aws_caller_identity.current.account_id}"
#  }
}

resource "aws_nat_gateway" "NGW-TF-Ansible-ELK" {
  allocation_id = "${aws_eip.NAT-EIP-TF-Ansible-ELK.id}"
  subnet_id     = "${aws_subnet.Subnet-Public-TF-Ansible-ELK.id}"
  depends_on = ["aws_internet_gateway.IGW-TF-Ansible-ELK"]
#  tags {
#      Name = "NATGW-TF-Ansible-ELK"
#      AccountID = "${data.aws_caller_identity.current.account_id}"
#  }
}



# VPC setup for NAT
resource "aws_route_table" "NAT-Route-TF-Ansible-ELK" {
    vpc_id = "${aws_vpc.VPC-TF-Ansible-ELK.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.NGW-TF-Ansible-ELK.id}"
    }
    tags {
        Name = "NATGW-TF-Ansible-ELK"
        AccountID = "${data.aws_caller_identity.current.account_id}"
    }
}

# Route Tables
resource "aws_route_table" "Route-TF-Ansible-ELK" {
    vpc_id = "${aws_vpc.VPC-TF-Ansible-ELK.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.IGW-TF-Ansible-ELK.id}"
    }
    tags {
        Name = "Route-TF-Ansible-ELK"
        AccountID = "${data.aws_caller_identity.current.account_id}"
    }
}



# Route Associations Public
resource "aws_route_table_association" "VPC-TF-Ansible-ELK" {
    subnet_id = "${aws_subnet.Subnet-Public-TF-Ansible-ELK.id}"
    route_table_id = "${aws_route_table.Route-TF-Ansible-ELK.id}"
}





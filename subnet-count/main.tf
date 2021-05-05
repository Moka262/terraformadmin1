#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
	Owner = "Hemanth"
	environment = "${var.environment}"
    }
}

resource "aws_internet_gateway" "Terra-IGW" {
    vpc_id = "${aws_vpc.main.id}"
	tags = {
        Name = "${var.IGW_name}"
    }
}
 
resource "aws_subnet" "subnets" {
    count = 3  #0,1,2
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${element(var.cidrs, count.index)}"
    availability_zone = "${element(var.azs, count.index)}"
    
     tags = {
        Name = "subnet-${count.index+1}"
    }
}

resource "aws_route_table" "terraform-RT" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.Terra-IGW.id}"
    }

    tags = {
        Name = "${var.Main_Routing_Table}"
    }
}

# resource "aws_route_table_association" "route-table-associ" {
#     count = 3  #0,1,2
#     subnet_id = "${element(aws_subnet.subnets.*.id, count.index)}"
#     route_table_id = "${element(aws_route_table.terraform-RT.route-table-associ.id)}"
# }

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  tags = {
      Name = "${var.SG_Name}"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}



provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}


resource "aws_vpc" "hit" {
    cidr_block = "${var.vpc_cidr}" 
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
        
	    Owner = "hemanthkumar"
    }
}




resource "aws_internet_gateway" "hit-igw" {
    vpc_id = "${aws_vpc.hit.id}"
	tags = {
        Name = "${var.IGW_name}"
    }
}

resource "aws_subnet" "sub-public" {
    vpc_id = "${aws_vpc.hit.id}"
    cidr_block = "${var.public_subnet1_cidr}"
    availability_zone = "${var.az1}"

    tags = {
        Name = "${var.public_subnet1_name}"
    }
}

resource "aws_subnet" "subnet2-public" {
    vpc_id = "${aws_vpc.hit.id}"
    cidr_block = "${var.public_subnet2_cidr}"
    availability_zone = "${var.az2}"

    tags = {
        Name = "${var.public_subnet2_name}"
    }
}

resource "aws_subnet" "subnet3-public" {
    vpc_id = "${aws_vpc.hit.id}"
    cidr_block = "${var.public_subnet3_cidr}"
    availability_zone = "${var.az3}"

    tags = {
        Name = "${var.public_subnet3_name}"
    }
	
}

resource "aws_subnet" "subnet4-public" {
    vpc_id = "${aws_vpc.hit.id}"
    cidr_block = "${var.public_subnet4_cidr}"
    availability_zone = "${var.az4}"

    tags = {
        Name = "${var.public_subnet4_name}"
    }
	
}


resource "aws_route_table" "terraform-public" {
    vpc_id = "${aws_vpc.hit.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.hit-igw.id}"
    }

    tags = {
        Name = "${var.Main_Routing_Table}"
    }
}

resource "aws_route_table_association" "terraform-public" {
    subnet_id = "${aws_subnet.sub-public.id}"
    route_table_id = "${aws_route_table.terraform-public.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.hit.id}"

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


# data "aws_ami" "my_ami" {
#      most_recent      = true
#      #name_regex       = "^mavrick"
#      owners           = ["721834156908"]
# }

 
# resource "aws_instance" "web-1" {
#     ami = var.imagename
#     #ami = "ami-0d857ff0f5fc4e03b"
#     availability_zone = "us-east-1a"
#     instance_type = "t2.micro"
#     key_name = "LaptopKey"
#     subnet_id = "${aws_subnet.subnet1-public.id}"
#     vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
#     associate_public_ip_address = true	
#     tags = {
#         Name = "Server-1"
#         Env = "Prod"
#         Owner = "Sree"
# 	CostCenter = "ABCD"
#     }
# }



##output "ami_id" {
#  value = "${data.aws_ami.my_ami.id}"
#}
#!/bin/bash
# echo "Listing the files in the repo."
# ls -al
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Packer Now...!!"
# packer build -var=aws_access_key=AAAAAAAAAAAAAAAAAA -var=aws_secret_key=BBBBBBBBBBBBB packer.json
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Terraform Now...!!"
# terraform init
# terraform apply --var-file terraform.tfvars -var="aws_access_key=AAAAAAAAAAAAAAAAAA" -var="aws_secret_key=BBBBBBBBBBBBB" --auto-approve
#https://discuss.devopscube.com/t/how-to-get-the-ami-id-after-a-packer-build/36

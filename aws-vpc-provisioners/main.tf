provider "aws" {
    region = "us-east-1"
}
resource "aws_vpc" "main" {
    cidr_block = var.cidr  
}
resource "aws_key_pair" "keypair" {
    key_name = "terraform"
    public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.cidr_subnet
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
}
resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.main.id
}
resource "aws_route_table" "route" {
    vpc_id = aws_vpc.main.id
     route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
    }
}
resource "aws_route_table_association" "route_table" {
    subnet_id = aws_subnet.subnet.id
    route_table_id = aws_route_table.route.id
}
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.main.id  # Reference to your existing VPC

  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}
resource "aws_instance" "instance1" {
    ami = var.ami_value
    instance_type = var.instance_type
    subnet_id = aws_subnet.subnet.id
    key_name = aws_key_pair.keypair.key_name
    vpc_security_group_ids = [aws_security_group.web_sg.id]

    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("~/.ssh/id_rsa")
        host = self.public_ip
    }
    provisioner "file" {
        source = "app.py"
        destination = "/home/ubuntu/app.py"
    }
    provisioner "remote-exec" {
        inline = [ 
            "sudo apt update -y",
            "sudo apt install -y python3 python3-pip",
            "cd /home/ubuntu",
            "sudo pip3 install flask",
            "sudo python3 app.py &",
         ]
         
    }
  
}





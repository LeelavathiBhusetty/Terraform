
provider "aws"{
    region = "us-east-1"
}
resource "aws_instance" "terraform" {
    ami ="ami-084568db4383264d4"
    subnet_id = "subnet-062a38d2515dc9eb0"
    key_name = "ansible"
    instance_type = "t2.micro"

    tags = {
    Name = "Terraform"
  }
}


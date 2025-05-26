provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source = "./modules-ec2-instance"
  ami_value="ami-084568db4383264d4"
  instance_type_value = "t2.micro"
  
}
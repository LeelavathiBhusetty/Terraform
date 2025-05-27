provider "aws" {
    region = "us-east-1"
  
}
resource "aws_instance" "instance" {
    ami = var.ami_value
    instance_type =var.instance_type_value
  
}
resource "aws_s3_bucket" "s3_bucket" {
    bucket = "prasanna-happy"
}
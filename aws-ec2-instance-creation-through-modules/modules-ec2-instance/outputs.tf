
//printing output of an ip address
output "public-ip-address" {
  value = aws_instance.instanceexample.public_ip
}


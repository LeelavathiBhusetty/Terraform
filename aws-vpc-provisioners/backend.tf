terraform {
  backend "s3" {
    bucket         = "prasanna-happy" 
    key            = "leela1/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    
  }
}
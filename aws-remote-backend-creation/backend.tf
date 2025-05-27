terraform {
  backend "s3" {
    bucket         = "prasanna-happy" 
    key            = "leela/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    
  }
}
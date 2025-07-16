terraform {
  backend "s3" {
    bucket  = "nelson-challenge-terraform-state-x7d8sx"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
} 
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "ansong84-terraform-backend-bucket"
    key            = "terraform-backend/dev/terraform.tfstate"
    region         = "us-east-2
    dynamodb_table = "backend-state-lock"
    encrypt        = true
  }
}

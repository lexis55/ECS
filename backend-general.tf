provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "ansong844-terraform-backend-bucket"
    key            = "terraform-backend/general/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "ansong844-backend-state-lock"
    encrypt        = true
  }
}

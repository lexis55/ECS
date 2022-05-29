terraform {
  backend "s3" {
    bucket         = "ansong844-terraform-backend-bucket"
    key            = "terraform-backend/dev/terraform.tfstate"
    region         = var.region
    dynamodb_table = "backend-state-lock"
    encrypt        = true
  }
}

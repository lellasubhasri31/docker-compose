terraform {
  backend "s3" {
    bucket         = "docker-compose09"
    key            = "talent-academy/backend/terraform.tfstates"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}
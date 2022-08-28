terraform {
  backend "s3" {
    bucket         = "netology-devops"
    key            = "state/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
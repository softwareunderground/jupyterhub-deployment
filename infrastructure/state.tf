terraform {
  backend "s3" {
    bucket         = "swunghub-v1-terraform-state"
    key            = "terraform/swunghub-v1.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "swunghub-v1-terraform-state-lock"
  }
}

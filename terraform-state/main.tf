provider "aws" {
  region = "eu-central-1"
}

module "terraform-state" {
  source = "/Users/filippo/Work/jupyterhub-terraform-modules/modules/aws/terraform-state"

  name = "swunghub-v1"

  tags = {
    Organization = "swunghub-v1"
    Project      = "terraform-state"
    Environment  = "dev"
  }
}

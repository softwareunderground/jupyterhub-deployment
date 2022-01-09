provider "aws" {
  region = var.region
}

module "terraform-state" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/aws/terraform-state"

  name = var.name

  tags = {
    Organization = var.organization
    Project      = var.name
    Owner        = "terraform"
    Environment  = var.environment
  }
}


locals {
  additional_tags = {
    Project      = var.name
    Organization = var.organization
    Owner        = "terraform"
    Environment  = var.environment
  }

  cluster_name = "${var.name}-${var.environment}"

  node_groups = {
    general = {
      key   = "eks.amazonaws.com/nodegroup"
      value = "general"
    }

    user = {
      key   = "eks.amazonaws.com/nodegroup"
      value = "user"
    }

    worker = {
      key   = "eks.amazonaws.com/nodegroup"
      value = "worker"
    }
  }
}

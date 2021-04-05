locals {
  additional_tags = {
    Project     = var.project_name
    Owner       = "terraform"
    Environment = var.environment
  }

  cluster_name = "${var.project_name}-${var.environment}"

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

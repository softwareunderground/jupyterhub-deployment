provider "aws" {
  region = var.region
}

# ==================== ACCOUNTING ======================
module "accounting" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/aws/accounting"

  project     = var.name
  environment = var.environment
}

# ======================= NETWORK ======================
module "network" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/aws/network"

  name = local.cluster_name

  tags = local.additional_tags

  vpc_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  security_group_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }

  vpc_cidr_block         = var.vpc_cidr_block
  aws_availability_zones = var.availability_zones
}

# ==================== REGISTRIES =====================
module "registry-jupyterlab" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/aws/registry"

  name = "${local.cluster_name}-jupyterlab"
  tags = local.additional_tags
}

# ====================== EFS =========================
module "efs" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/aws/efs"

  name = "${local.cluster_name}-jupyterhub-shared"
  tags = local.additional_tags

  efs_subnets         = module.network.subnet_ids
  efs_security_groups = [module.network.security_group_id]
}

# ==================== KUBERNETES =====================
module "kubernetes" {
  source = "github.com/softwareunderground/jupyterhub-terraform-modules//modules/aws/kubernetes"

  name = local.cluster_name
  tags = local.additional_tags

  cluster_subnets         = module.network.subnet_ids
  cluster_security_groups = [module.network.security_group_id]

  node_group_additional_policies = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]

  node_groups = [

    {
      name          = "general"
      instance_type = "m5.large"
      min_size      = 1
      desired_size  = 1
      max_size      = 1
    },

    {
      name          = "user"
      instance_type = "m5.large"
      min_size      = 1
      desired_size  = 1
      max_size      = 2
    },

    {
      name          = "worker"
      instance_type = "m5.large"
      min_size      = 1
      desired_size  = 1
      max_size      = 2
    },

  ]

  dependencies = [
    module.network.depended_on
  ]
}

variable "organization" {
  type    = string
}

variable "name" {
  type    = string
}

variable "environment" {
  type    = string
}

variable "region" {
  type    = string
}

variable "availability_zones" {
  description = "AWS availability zones within AWS region"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "VPC cidr block for infastructure"
  type        = string
  default     = "10.10.0.0/16"
}

variable "conda_environments" {
  description = "Conda environments available to the users"
  type        = list(string)
  default     = ["environment-default.yaml"]
}

variable "conda-store-image" {
  description = "Conda-store image"
  type = object({
    name = string
    tag  = string
  })
  default = {
    name = "quansight/qhub-conda-store"
    tag  = "v0.3.14"
  }
}


variable "name" {
  type    = string
}

variable "environment" {
  type    = string
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "availability_zones" {
  description = "AWS availability zones within AWS region"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
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

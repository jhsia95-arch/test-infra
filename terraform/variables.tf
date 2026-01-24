variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "name" {
  default = "tech-assessment-eks"
}

variable "ecr_repo" {
  default = "webapp"
}

variable "k8s_version" {
  default = "1.34"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
variable "private_subnet_cidr_blocks" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "public_subnet_cidr_blocks" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "database_subnet_cidr_blocks" {
  default = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "tags" {
  default = {
    App = "eks-cluster"
  }
}

# variable "db_password" {
#   description = "RDS master password"
#   type        = string
#   sensitive   = true
#   default = "test"
# }

variable "cluster_name" {
  default = "tech-assessment-eks"
}
variable "namespace" {
  default = "default"
}
variable "service_account_name" {
  default = "fastapi-sa"
}
variable "rds_secret_arn" {
  default = "arn:aws:secretsmanager:ap-southeast-1:995597568618:secret:rds!db*"
}

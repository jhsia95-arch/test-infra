module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  identifier = "tech-assessment-db"

  engine            = "postgres"
  engine_version    = "15.4"       # pick latest stable
  instance_class    = "db.t3.medium"
  allocated_storage = 20

  db_name      = "postgresdb"              # Database name
  username = "dbadmin"            # Master user
  password = var.db_password      # Stored in terraform variable or secret

  # Use private subnets for isolation
  subnet_ids = module.vpc.database_subnets

  # Multi-AZ for production (optional)
  multi_az = false

  # Security groups
  vpc_security_group_ids = [module.db_sg.security_group_id]
  db_parameter_group_family = "postgres15"

  skip_final_snapshot = true       # for dev/testing only
  deletion_protection = false      # for dev/testing only

  tags = var.tags
}

module "db_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "db-sg"
  description = "Allow EKS to talk to RDS"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {     
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = "10.0.0.0/16"
      description = "EKS nodes access"
    }
  ]
}


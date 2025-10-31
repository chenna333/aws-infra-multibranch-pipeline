# Create VPC
module "vpc" {
  source     = "./modules/vpc"
  env        = var.env
  cidr_block = var.cidr_block
  region     = var.aws_region
}

# Create Bastion (single EC2 in a public subnet)
module "bastion" {
  source           = "./modules/bastion"
  env              = var.env
  public_subnet_id = module.vpc.public_subnets[0]
  key_name         = lookup(var, "bastion_key_name", null)
}

# Create EKS cluster + single managed node group
module "eks" {
  source       = "./modules/eks"
  cluster_name = "${var.env}-eks-cluster"
  region       = var.aws_region
  subnet_ids   = module.vpc.private_subnets
}

# Create RDS
module "rds" {
  source             = "./modules/rds"
  env                = var.environment
  subnet_ids         = module.vpc.private_subnets
  allocated_storage  = var.db_allocated_storage
  instance_class     = var.db_instance_class
  db_name            = var.db_name
}


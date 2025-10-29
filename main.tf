provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  env    = var.env
  cidr_block = var.cidr_block
}

module "eks" {
  source = "./modules/eks"
  cluster_name = "${var.env}-eks-cluster"
  subnet_ids   = module.vpc.private_subnets
}

module "rds" {
  source = "./modules/rds"
  db_name   = "${var.env}_db"
  subnet_ids = module.vpc.private_subnets
}

module "bastion" {
  source = "./modules/bastion"
  env          = var.env
  public_subnet_id = module.vpc.public_subnets[0]
}


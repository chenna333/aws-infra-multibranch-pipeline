env              = "qa"
region           = "us-east-1"
vpc_cidr         = "10.1.0.0/16"

public_subnets   = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets  = ["10.1.3.0/24", "10.1.4.0/24"]

eks_cluster_name = "qa-eks-cluster"
eks_node_count   = 2
eks_instance_type = "t3.medium"

db_name           = "qadb"
db_username       = "qaadmin"
db_password       = "qa@12345"
db_instance_class = "db.t3.micro"
db_allocated_storage = 20

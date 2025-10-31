env              = "dev"
region           = "us-east-1"
vpc_cidr         = "10.0.0.0/16"

public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

eks_cluster_name = "dev-eks-cluster"
eks_node_count   = 2
eks_instance_type = "t3.medium"

db_name           = "devdb"
db_instance_class = "db.t3.micro"
db_allocated_storage = 20

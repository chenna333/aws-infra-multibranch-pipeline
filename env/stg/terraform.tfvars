environment       = "stg"
region            = "eastus"
vpc_cidr          = "10.30.0.0/16"

public_subnets    = ["10.30.1.0/24", "10.30.2.0/24"]
private_subnets   = ["10.30.3.0/24", "10.30.4.0/24"]

eks_cluster_name  = "stg-eks-cluster"
eks_node_count    = 2
eks_instance_type = "t3.medium"

db_name           = "stgdb"
db_instance_class = "db.t3.medium"
db_allocated_storage = 20


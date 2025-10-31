environment       = "prod"
region            = "eastus"
vpc_cidr          = "10.50.0.0/16"

public_subnets    = ["10.50.1.0/24", "10.50.2.0/24"]
private_subnets   = ["10.50.3.0/24", "10.50.4.0/24"]

eks_cluster_name  = "prod-eks-cluster"
eks_node_count    = 4
eks_instance_type = "t3.large"

db_name           = "proddb"
db_instance_class = "db.t3.large"
db_allocated_storage = 50


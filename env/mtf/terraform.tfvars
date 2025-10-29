environment       = "mtf"
region            = "eastus"
vpc_cidr          = "10.40.0.0/16"

public_subnets    = ["10.40.1.0/24", "10.40.2.0/24"]
private_subnets   = ["10.40.3.0/24", "10.40.4.0/24"]

eks_cluster_name  = "mtf-eks-cluster"
eks_node_count    = 3
eks_instance_type = "t3.medium"

db_name           = "mtfdb"
db_username       = "mtfadmin"
db_password       = "mtf@12345"
db_instance_class = "db.t3.medium"
db_allocated_storage = 20


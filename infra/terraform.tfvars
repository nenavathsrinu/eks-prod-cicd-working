region       = "ap-south-2"
cluster_name = "prod-eks"
account_id   = "442880721659"

vpc_cidr = "10.0.0.0/16"

public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

azs = ["ap-south-2a", "ap-south-2b"]

instance_types = ["t3.small"]

desired_size = 2
min_size     = 1
max_size     = 4

disk_size     = 50
capacity_type = "ON_DEMAND"

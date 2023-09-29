profile            = "akhil"
region             = "us-west-1"
project_name       = "eks"
vpc_cidr           = "10.0.0.0/16"
subnet_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
assign_public_ip   = [true, true, true, true, true, false]
tags               = ["pub1", "pub2", "app1", "app2", "db1", "db2"]
availability_zones = ["us-west-1c", "us-west-1b", "us-west-1c", "us-west-1b", "us-west-1c", "us-west-1b"]
#eks
cluster_name         = "sta_cluster"
cluster_version      = "1.26"
create_node_group    = true
number_of_nodegroups = 1
node_group_name      = "node-group-1"
desired_size         = 2
max_size             = 4
min_size             = 1
ami_type             = "AL2_x86_64"
capacity_type        = "ON_DEMAND"
instance_types       = ["t3.medium"]
#controller
thumbprint_list = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
client_id_list  = "sts.amazonaws.com"

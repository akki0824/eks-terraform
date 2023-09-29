terraform {
  backend "s3" {
    profile = "TAS"
    bucket  = "sta-bucketz-1"
    key     = "sta/vpc/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # dynamodb_table = "sta-table"
  }
}
module "vpc" {
  source             = "git::https://github.com/akki0824/modules.git//vpc?ref=feature"
  region             = var.region
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  subnet_cidr_block  = var.subnet_cidr_block
  availability_zones = var.availability_zones
  assign_public_ip   = var.assign_public_ip
  tags               = var.tags
}

module "eks" {
  source               = "git::https://github.com/akki0824/modules.git//eks?ref=feature"
  region               = var.region
  cluster_name         = var.cluster_name
  cluster_version      = var.cluster_version
  create_node_group    = var.create_node_group
  number_of_nodegroups = var.number_of_nodegroups
  node_group_name      = var.node_group_name
  desired_size         = var.desired_size
  max_size             = var.max_size
  min_size             = var.min_size
  ami_type             = var.ami_type
  capacity_type        = var.capacity_type
  instance_types       = var.instance_types
  subnet_ids           = [module.vpc.subnet_ids[0], module.vpc.subnet_ids[1]]
  node_group_subnet_id = [module.vpc.subnet_ids[2], module.vpc.subnet_ids[3]]
  role_arn             = aws_iam_role.eks_cluster_role.arn
  node_role_arn        = aws_iam_role.worker-role.arn
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}

data "aws_caller_identity" "current" {}

resource "null_resource" "local_downloads" {
  depends_on = [ module.eks ]
  provisioner "local-exec" {
    command = <<EOT
aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region} --profile ${var.profile}

EOT
  }

}


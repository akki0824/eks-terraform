/* output "cluster_id" {
  description = "EKS cluster ID."
  value       = aws_eks_cluster.sta_cluster.id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = aws_eks_cluster.sta_cluster.endpoint
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.sta_cluster.name
}

output "identity" {
  value = module.eks.identity
}

output "oidc_id" {
  value = aws_iam_openid_connect_provider.default.id
  
}*/
output "identity" {
  value = module.eks.identity
}

output "oidc_id" {
  value = aws_iam_openid_connect_provider.default.id
}

output "cluster_details" {
  value = module.eks.cluster_details

}

output "subnet_ids" {
  value = module.vpc.subnet_ids
}
output "identity_all" {
  value = module.eks.identity_all

}

output "cluster_all" {
  value = module.eks.cluster_all

}




  
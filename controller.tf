#LB controller role 
resource "aws_iam_policy" "custom_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"                # Replace with the desired policy name
  description = "creating policy from json file for ALB controller" # Replace with a description

  # Specify the policy document as a JSON string
  policy = file("./iam_policy.json")
  depends_on = [ null_resource.local_downloads ]
}

resource "aws_iam_role" "AmazonEKSLoadBalancerControllerRole" {
  name               = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${data.aws_caller_identity.current.id}:oidc-provider/oidc.eks.us-west-1.amazonaws.com/id/864ADA0CE43D4B6861FEDB3048244AC3"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.${var.region}.amazonaws.com/id/864ADA0CE43D4B6861FEDB3048244AC3:aud": "sts.amazonaws.com",
                    "oidc.eks.${var.region}.amazonaws.com/id/864ADA0CE43D4B6861FEDB3048244AC3:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }
        }
    ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "policy" {
  policy_arn = aws_iam_policy.custom_policy.arn
  role       = aws_iam_role.AmazonEKSLoadBalancerControllerRole.name

}

resource "aws_iam_openid_connect_provider" "default" {
  url             = module.eks.identity
  client_id_list  = [var.client_id_list]
  thumbprint_list = [var.thumbprint_list]
}

resource "kubernetes_service_account" "aws-load-balancer-controller-service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = { "app.kubernetes.io/component" = "controller"
    "app.kubernetes.io/name" = "aws-load-balancer-controller" }
    annotations = { "eks.amazonaws.com/role-arn" = "${aws_iam_role.AmazonEKSLoadBalancerControllerRole.arn}" }
  }
}

/* resource "helm_release" "aws_load_balancer_controller" {
  depends_on = [ aws_iam_role.AmazonEKSLoadBalancerControllerRole ]
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  
  # version    = "1.2.3" # Replace with the desired chart version
  timeout = 300
  set {
    name = "clusterName"
    value = var.cluster_name
  }
  set {
    name = "serviceAccount.create"
    value = "false"
  }
  set {
    name = "serviceAccount.name"
    value = "aws-load-balancer-controller "
  }
  set {
    name = "image.repository"
    value = "602401143452.dkr.ecr.us-west-1.amazonaws.com"
    
  }
}*/

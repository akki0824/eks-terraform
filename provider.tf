provider "aws" {
    region = var.region
    profile = var.profile
  
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.5"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = ""
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" 
     cluster_ca_certificate = "base64decode(arn:aws:iam::301167228985:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/04BDBBF84E9028F8613F98CEF91B89CC)"
  }
}

provider "null" {}

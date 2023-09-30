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
  config_context = "arn:aws:eks:us-west-1:231299874646:cluster/sta_cluster"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" 
  }
}

provider "null" {}

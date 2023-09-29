resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "example-app-1"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "example-app-1"
      }
    }

    template {
      metadata {
        labels = {
          test = "example-app-1"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "example-app-1"
          port {
            container_port = 80
          }


          resources {
            limits = {
              cpu    = "500m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "lb" {
  metadata {
    name = "terraform-example"
  }
  spec {
    selector = {
      test = "example-app-1"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
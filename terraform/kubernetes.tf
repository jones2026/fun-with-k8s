provider "kubernetes" {
  load_config_file = false

  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

resource "kubernetes_deployment" "api" {
  metadata {
    name = "fun-with-k8s"
    labels = {
      App = "fun-with-k8s"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "fun-with-k8s"
      }
    }
    template {
      metadata {
        labels = {
          App = "fun-with-k8s"
        }
      }
      spec {
        container {
          image = "jones2026/fun-with-k8s"
          name  = "fun-with-k8s"

          port {
            container_port = 8080
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    google_container_cluster.primary
  ]
}


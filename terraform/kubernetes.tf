# provider "kubernetes" {
#   load_config_file = false

#   host     = google_container_cluster.primary.endpoint
#   username = google_container_cluster.primary.master_auth[0].username
#   password = google_container_cluster.primary.master_auth[0].password

#   client_certificate     = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
#   client_key             = base64decode(google_container_cluster.primary.master_auth.0.client_key)
#   cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
# }


provider "kubernetes" {
  load_config_file = false

  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "fun-with-k8s"
    labels = {
      App = "FunWithK8s"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "FunWithK8s"
      }
    }
    template {
      metadata {
        labels = {
          App = "FunWithK8s"
        }
      }
      spec {
        container {
          image = "jones2026/fun-with-k8s"
          name  = "FunWithK8s"

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


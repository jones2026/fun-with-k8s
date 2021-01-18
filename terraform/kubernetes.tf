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
    name = "scalable-nginx-example"
    labels = {
      App = "ScalableNginxExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "example"

          port {
            container_port = 80
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


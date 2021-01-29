provider "kubernetes" {
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
      app = "fun-with-k8s"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "fun-with-k8s"
      }
    }
    template {
      metadata {
        labels = {
          app = "fun-with-k8s"
        }
      }
      spec {
        container {
          image = "jones2026/fun-with-k8s:${var.api_version}"
          name  = "fun-with-k8s"

          liveness_probe {
            http_get {
              path = "/api/v1/healthz"
              port = 8080
            }
            period_seconds = 2
          }

          readiness_probe {
            http_get {
              path = "/api/v1/healthz"
              port = 8080
            }
            period_seconds = 2
          }

          port {
            container_port = 8080
          }

          resources {
            limits  = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests  = {
              cpu    = "125m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    google_container_node_pool.np
  ]
}

resource "kubernetes_service" "api" {
  metadata {
    name = "fun-with-k8s"
    labels = {
      app = "fun-with-k8s"
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = kubernetes_deployment.api.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }
  }
}

output "api_url" {
  value = "http://${kubernetes_service.api.status[0].load_balancer[0].ingress[0].ip}/api/v1/automate"
}

resource "null_resource" "env_file" {
  triggers = {
    timestamp = timestamp()
  }
  provisioner "local-exec" {
    command = "echo 'export BASE_URL=${kubernetes_service.api.status[0].load_balancer[0].ingress[0].ip}/api/v1' > ../test.env"
  }
}

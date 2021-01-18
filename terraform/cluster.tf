provider "google" {
  project = "fun-with-k8s-301821"
  region  = "us-central1"
}

data "google_client_config" "provider" {}

resource "google_container_cluster" "primary" {
  name               = "my-gke-cluster"
  location           = "us-central1-c"
  initial_node_count = 3
  node_config {
    preemptible = true
  }
}
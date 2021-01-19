provider "google" {
  project = "fun-with-k8s-301821"
  region  = "us-central1"
}

data "google_client_config" "provider" {}

resource "google_container_cluster" "primary" {
  name                     = "my-gke-cluster"
  location                 = "us-central1-c"
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "np" {
  name     = "my-node-pool"
  location = "us-central1-c"
  cluster  = google_container_cluster.primary.name

  initial_node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 6
  }

  management {
    auto_repair = true
  }

  node_config {
    preemptible = true
  }
}

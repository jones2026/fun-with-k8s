terraform {
  backend "gcs" {
    bucket = "jones2026-tf-state"
    prefix = "fun-with-k8s"
  }
}

provider "google" {
  project = "fun-with-k8s-301821"
  region  = "us-central1"
}

resource "google_container_cluster" "primary" {
  name               = "my-gke-cluster"
  location           = "us-central1"
  initial_node_count = 1
  node_config {
    preemptible = true
  }
}

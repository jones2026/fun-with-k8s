terraform {
  backend "gcs" {
    bucket = "jones2026-tf-state"
    prefix = "fun-with-k8s"
  }
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.52"
    }
  }
}

variable "api_version" {
  default = "latest"
  description = "The version of the api image to deploy"
}
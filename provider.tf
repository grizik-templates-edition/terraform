terraform {
  required_version = ">= 0.14"

  required_providers {
    google = ">= 3.3"
  }
}

provider "google" {
  project = var.project_id
  credentials = var.service_token
  region = var.region
  zone = var.zone

}
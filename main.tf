locals {
  services = [
    "cloudresourcemanager.googleapis.com",
    "storage-component.googleapis.com",
    "storage-api.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com",
  ]
}

# Enables the Cloud Run API
resource "google_project_service" "apis" {
  for_each = toset(local.services)
  service = each.key
  disable_on_destroy = true
}

resource "google_storage_bucket" "cc-static-generated" {
  name          = var.project_name
  location      = var.region
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["*/*"]
    method          = ["GET"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  
  # Waits for the GCP API to be enabled
  depends_on = [google_project_service.apis]
}


# Allow unauthenticated users to view the service
resource "google_storage_bucket_access_control" "website_read" {
  bucket = google_storage_bucket.cc-static-generated.name
  role   = "READER"
  entity = "allUsers"
}

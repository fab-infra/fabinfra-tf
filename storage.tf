// GCS bucket for project files
resource "google_storage_bucket" "gcs_bucket_project" {
  name                        = var.gcp_project_id
  project                     = var.gcp_project_id
  location                    = var.gcp_region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

// GCS bucket for backups
resource "google_storage_bucket" "gcs_bucket_backups" {
  name                        = "${var.gcp_project_id}-backups"
  project                     = var.gcp_project_id
  location                    = "europe-west1"
  storage_class               = "COLDLINE"
  uniform_bucket_level_access = true
}

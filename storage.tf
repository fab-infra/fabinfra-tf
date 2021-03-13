// GCS bucket for backups
resource "google_storage_bucket" "gcs_bucket_backups" {
  name                        = "${var.gcp_project_id}-backups"
  project                     = var.gcp_project_id
  location                    = "europe-west1"
  storage_class               = "COLDLINE"
  uniform_bucket_level_access = true
}

// OVH storage buckets
resource "ovh_cloud_project_storage" "ovh_bucket" {
  for_each     = toset(var.storage_bucket_names)
  service_name = var.ovh_project_id
  region_name  = var.ovh_region
  name         = "${var.storage_bucket_prefix}-${each.value}"
}

// OVH storage buckets lifecycle rules
resource "ovh_cloud_project_storage_object_bucket_lifecycle_configuration" "ovh_bucket_lifecycle" {
  for_each       = var.storage_bucket_rules
  service_name   = ovh_cloud_project_storage.ovh_bucket[each.key].service_name
  region_name    = ovh_cloud_project_storage.ovh_bucket[each.key].region_name
  container_name = ovh_cloud_project_storage.ovh_bucket[each.key].name
  rules          = each.value
}

// GCS bucket for project files
resource "google_storage_bucket" "gcs_bucket_project" {
  name                        = var.gcp_project_id
  project                     = var.gcp_project_id
  location                    = var.gcp_region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

// GCS buckets for backups
resource "google_storage_bucket" "gcs_bucket" {
  for_each                    = toset(var.storage_bucket_names)
  name                        = "${var.storage_bucket_prefix}-${each.value}"
  project                     = var.gcp_project_id
  location                    = var.gcp_region
  storage_class               = "COLDLINE"
  uniform_bucket_level_access = true
}

// Service Account with Storage Object Admin role
resource "google_service_account" "gcs_sa" {
  account_id   = "storage-writer"
  project      = var.gcp_project_id
  display_name = "Cloud Storage Writer"
}
resource "google_project_iam_member" "gcs_sa_iam_object_admin" {
  project = var.gcp_project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.gcs_sa.email}"
}

// VPN instance
resource "google_compute_instance" "vpn_instance" {
  for_each                  = toset(var.vpn_zones)
  name                      = "vpn-${each.value}"
  machine_type              = var.vpn_machine_type
  zone                      = each.value
  allow_stopping_for_update = true
  can_ip_forward            = true
  tags                      = ["openvpn"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip       = google_compute_address.vpn_ip[each.key].address
      network_tier = "STANDARD"
    }
  }

  metadata = {
    startup-script-url = "gs://${google_storage_bucket_object.vpn_startup_script.bucket}/${google_storage_bucket_object.vpn_startup_script.output_name}"
  }

  service_account {
    email  = google_service_account.vpn_sa.email
    scopes = ["cloud-platform"]
  }
}

// External IP
resource "google_compute_address" "vpn_ip" {
  for_each     = toset(var.vpn_zones)
  name         = "vpn-ip-${each.value}"
  region       = replace(each.value, "/-[^-]+$/", "")
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}

// Startup script
resource "google_storage_bucket_object" "vpn_startup_script" {
  name   = "vpn_startup_script.sh"
  bucket = google_storage_bucket.gcs_bucket_project.name
  content = templatefile("${path.module}/vpn/startup_script.sh", {
    cacert_secret_id     = google_secret_manager_secret.vpn_cacert_secret.secret_id
    servercert_secret_id = google_secret_manager_secret.vpn_servercert_secret.secret_id
    serverkey_secret_id  = google_secret_manager_secret.vpn_serverkey_secret.secret_id
  })
}

// VPN CA secret
resource "google_secret_manager_secret" "vpn_cacert_secret" {
  secret_id = "vpn-cacert"

  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "vpn_cacert_secret_version" {
  secret      = google_secret_manager_secret.vpn_cacert_secret.id
  secret_data = var.vpn_cacert
}

// VPN public key secret
resource "google_secret_manager_secret" "vpn_servercert_secret" {
  secret_id = "vpn-servercert"

  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "vpn_servercert_secret_version" {
  secret      = google_secret_manager_secret.vpn_servercert_secret.id
  secret_data = var.vpn_servercert
}

// VPN private key secret
resource "google_secret_manager_secret" "vpn_serverkey_secret" {
  secret_id = "vpn-serverkey"

  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "vpn_serverkey_secret_version" {
  secret      = google_secret_manager_secret.vpn_serverkey_secret.id
  secret_data = var.vpn_serverkey
}

// Service account
resource "google_service_account" "vpn_sa" {
  account_id   = "vpn-instance"
  display_name = "VPN Service Account"
}
resource "google_project_iam_member" "vpn_sa_iam_log_writer" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.vpn_sa.email}"
}
resource "google_project_iam_member" "vpn_sa_iam_metric_writer" {
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.vpn_sa.email}"
}
resource "google_storage_bucket_iam_member" "vpn_sa_iam_object_viewer" {
  bucket = google_storage_bucket.gcs_bucket_project.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.vpn_sa.email}"
}
resource "google_secret_manager_secret_iam_member" "vpn_sa_iam_secret_accessor_ca" {
  secret_id = google_secret_manager_secret.vpn_cacert_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.vpn_sa.email}"
}
resource "google_secret_manager_secret_iam_member" "vpn_sa_iam_secret_accessor_servercert" {
  secret_id = google_secret_manager_secret.vpn_servercert_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.vpn_sa.email}"
}
resource "google_secret_manager_secret_iam_member" "vpn_sa_iam_secret_accessor_serverkey" {
  secret_id = google_secret_manager_secret.vpn_serverkey_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.vpn_sa.email}"
}

// Firewall rule
resource "google_compute_firewall" "vpn_firewall" {
  name          = "allow-openvpn"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["openvpn"]

  allow {
    protocol = "tcp"
    ports    = ["443", "1194"]
  }
}

// DNS record
resource "ovh_domain_zone_record" "vpn_dns_record" {
  for_each  = toset(var.vpn_zones)
  zone      = var.dns_zone
  subdomain = "vpn-${each.value}"
  fieldtype = "A"
  ttl       = 300
  target    = google_compute_address.vpn_ip[each.key].address
}

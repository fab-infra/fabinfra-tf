// DNS records
resource "ovh_domain_zone_record" "dns_records" {
  for_each  = { for rec in var.dns_records : sha1("${rec.name}_${rec.type}_${rec.target}") => rec }
  zone      = var.dns_zone
  subdomain = each.value.name
  fieldtype = each.value.type
  ttl       = each.value.ttl
  target    = each.value.target
}

// GCP zone
resource "google_dns_managed_zone" "dns_gcp_zone" {
  name     = "gcp-${var.gcp_project_id}"
  dns_name = "gcp.${var.dns_zone}."
  project  = var.gcp_project_id
  dnssec_config {
    state = "on"
  }
}

// GCP zone DNSSEC config
data "google_dns_keys" "dns_gcp_keys" {
  managed_zone = google_dns_managed_zone.dns_gcp_zone.id
}

// GCP zone NS record
resource "ovh_domain_zone_record" "dns_gcp_ns_records" {
  for_each  = toset(google_dns_managed_zone.dns_gcp_zone.name_servers)
  zone      = var.dns_zone
  subdomain = "gcp"
  fieldtype = "NS"
  ttl       = 0
  target    = each.value
}

// GCP zone DS record
/* DISABLED: not supported by OVH (yet)
resource "ovh_domain_zone_record" "dns_gcp_ds_records" {
  for_each  = { for ksk in data.google_dns_keys.dns_gcp_keys.key_signing_keys : ksk.id => ksk }
  zone      = var.dns_zone
  subdomain = "gcp"
  fieldtype = "DS"
  ttl       = 0
  target    = each.value.ds_record
}
*/

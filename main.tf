provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

resource "ovh_domain_zone_record" "dns_records" {
  for_each = {for rec in var.dns_records: sha1("${rec.name}_${rec.type}_${rec.target}") => rec}
  zone      = var.dns_zone
  subdomain = each.value.name
  fieldtype = each.value.type
  ttl       = each.value.ttl
  target    = each.value.target
}

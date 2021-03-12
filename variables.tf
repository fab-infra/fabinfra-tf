// OVH provider
variable "ovh_endpoint" {
  description = "OVH API endpoint"
}
variable "ovh_application_key" {
  description = "OVH application key"
  sensitive   = true
}
variable "ovh_application_secret" {
  description = "OVH application secret"
  sensitive   = true
}
variable "ovh_consumer_key" {
  description = "OVH consumer key"
  sensitive   = true
}

// Google Cloud provider
variable "gcp_credentials" {
  description = "Terraform service account credentials JSON file"
  sensitive   = true
}
variable "gcp_project_id" {
  description = "GCP project ID"
}
variable "gcp_region" {
  description = "GCP region"
}

// DNS config
variable "dns_zone" {
  description = "DNS zone name"
}
variable "dns_records" {
  default = []
  type = list(object({
    name   = string
    ttl    = number
    type   = string
    target = string
  }))
  description = "DNS records"
}

variable "ovh_endpoint" {
  description = "OVH API endpoint"
}
variable "ovh_application_key" {
  description = "OVH application key"
}
variable "ovh_application_secret" {
  description = "OVH application secret"
}
variable "ovh_consumer_key" {
  description = "OVH consumer key"
}
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

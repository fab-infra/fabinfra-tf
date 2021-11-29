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

// Kubernetes provider
variable "k8s_host" {
  description = "Kubernetes master host name"
}
variable "k8s_client_cert" {
  description = "Kubernetes client certificate (base64-encoded PEM)"
}
variable "k8s_client_key" {
  description = "Kubernetes client private key (base64-encoded PEM)"
  sensitive   = true
}
variable "k8s_ca_cert" {
  description = "Kubernetes cluster CA certificate (base64-encoded PEM)"
}

// Kubernetes config
variable "k8s_calico_version" {
  description = "Calico Helm chart version"
}
variable "k8s_certmanager_version" {
  description = "Cert-manager Helm chart version"
}
variable "k8s_dashboard_version" {
  description = "Kubernetes Dashboard Helm chart version"
}
variable "k8s_elastic_operator_version" {
  description = "Elastic ECK operator Helm chart version"
}
variable "k8s_ingress_nginx_version" {
  description = "Ingress Nginx Helm chart version"
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

// Infra
variable "infra_namespace" {
  description = "Infra Kubernetes namespace"
}

// Uptime checks
variable "uptime_check_urls" {
  default     = []
  type        = list(string)
  description = "Uptime check HTTPS URLs"
}
variable "uptime_check_notification_email" {
  description = "Uptime check notification email address"
}

// VPN
variable "vpn_machine_type" {
  description = "VPN instance machine type"
}
variable "vpn_zones" {
  default     = []
  type        = list(string)
  description = "VPN instance zones (e.g. us-east1-b, europe-west1-b)"
}
variable "vpn_cacert" {
  description = "VPN certificate authority (PEM-encoded)"
  sensitive   = true
}
variable "vpn_servercert" {
  description = "VPN server certificate (PEM-encoded)"
  sensitive   = true
}
variable "vpn_serverkey" {
  description = "VPN server key (PEM-encoded)"
  sensitive   = true
}

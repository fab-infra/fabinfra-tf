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
variable "gcp_billing_notification_email" {
  description = "GCP billing notification email address"
}

// Grafana provider
variable "grafana_url" {
  description = "Grafana URL"
}
variable "grafana_auth" {
  description = "Grafana API key"
  sensitive   = true
}
variable "grafana_sm_url" {
  description = "Grafana Synthetic Monitoring URL"
}
variable "grafana_sm_access_token" {
  description = "Grafana Synthetic Monitoring access token"
  sensitive   = true
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
variable "k8s_certmanager_root_ca_crt" {
  description = "Root CA certificate (PEM-encoded)"
  sensitive   = true
}
variable "k8s_certmanager_root_ca_key" {
  description = "Root CA key (PEM-encoded)"
  sensitive   = true
}
variable "k8s_elastic_operator_version" {
  description = "Elastic ECK operator Helm chart version"
}
variable "k8s_ingress_nginx_version" {
  description = "Ingress Nginx Helm chart version"
}
variable "k8s_ingress_nginx_external_ips" {
  type        = list(string)
  description = "Ingress Nginx external IPs list"
}
variable "k8s_kubelet_csr_approver_version" {
  description = "Kubelet CSR Approver chart version"
}
variable "k8s_metrics_server_version" {
  description = "Metrics Server chart version"
}
variable "k8s_openebs_version" {
  description = "OpenEBS chart version"
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
variable "infra_otelcol_otlphttp_endpoint" {
  description = "OpenTelemetry OTLP HTTP endpoint"
}
variable "infra_otelcol_otlphttp_username" {
  description = "OpenTelemetry OTLP HTTP username"
}
variable "infra_otelcol_otlphttp_password" {
  description = "OpenTelemetry OTLP HTTP password"
  sensitive   = true
}
variable "infra_otelcol_version" {
  description = "OpenTelemetry Collector Helm chart version"
}

// Uptime checks
variable "uptime_check_urls" {
  default     = []
  type        = list(string)
  description = "Uptime check HTTPS URLs"
}
variable "uptime_frequency" {
  description = "Uptime check frequency (ms)"
}
variable "uptime_timeout" {
  description = "Uptime check timeout (ms)"
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

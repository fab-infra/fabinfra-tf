// Public probes
data "grafana_synthetic_monitoring_probes" "sm_probes" {
}

// HTTP checks
resource "grafana_synthetic_monitoring_check" "sm_http_check" {
  for_each          = toset(var.uptime_check_urls)
  job               = replace(each.value, "/(^https?://|/.*$)/", "")
  target            = each.value
  frequency         = var.uptime_frequency
  timeout           = var.uptime_timeout
  alert_sensitivity = "medium"
  probes = [
    data.grafana_synthetic_monitoring_probes.sm_probes.probes.Paris
  ]
  labels = {
    domain = replace(each.value, "/(^https?://[^.]+\\.|/.*$)/", "")
  }
  settings {
    http {}
  }
}

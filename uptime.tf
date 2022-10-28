// Public probes
data "grafana_synthetic_monitoring_probes" "sm_probes" {
}

// HTTP checks
resource "grafana_synthetic_monitoring_check" "sm_http_check" {
  for_each          = toset(var.uptime_check_urls)
  job               = replace(each.value, "/(^https?://|/.*$)/", "")
  target            = each.value
  frequency         = 60000
  timeout           = 10000
  alert_sensitivity = "medium"
  probes = [
    data.grafana_synthetic_monitoring_probes.sm_probes.probes.Paris,
    data.grafana_synthetic_monitoring_probes.sm_probes.probes.NewYork
  ]
  labels = {
    domain = replace(each.value, "/(^https?://[^.]+\\.|/.*$)/", "")
  }
  settings {
    http {}
  }
}

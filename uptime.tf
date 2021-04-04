resource "google_monitoring_uptime_check_config" "uptime_check" {
  for_each     = toset(var.uptime_check_urls)
  display_name = replace(each.value, "/(^https?://|/.*$)/", "")
  timeout      = "10s"
  period       = "60s"

  http_check {
    path         = replace(each.value, "/^https?://[^/]+/", "")
    port         = length(regexall("^https://", each.value)) > 0 ? "443" : "80"
    use_ssl      = length(regexall("^https://", each.value)) > 0
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.gcp_project_id
      host       = replace(each.value, "/(^https?://|/.*$)/", "")
    }
  }
}

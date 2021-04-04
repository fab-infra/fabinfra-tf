// Uptime checks
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

// Alert policies
resource "google_monitoring_alert_policy" "uptime_alert_policy" {
  for_each              = google_monitoring_uptime_check_config.uptime_check
  display_name          = "Uptime check on ${each.value.display_name}"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.uptime_notification_channel_email.name]

  conditions {
    display_name = "Uptime check on ${each.value.display_name}"

    condition_threshold {
      filter          = "resource.type=\"uptime_url\" metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" metric.label.\"check_id\"=\"${basename(each.value.id)}\""
      duration        = "180s"
      comparison      = "COMPARISON_GT"
      threshold_value = 1

      aggregations {
        alignment_period     = "1200s"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.*"]
        per_series_aligner   = "ALIGN_NEXT_OLDER"
      }

      trigger {
        count = 1
      }
    }
  }

  documentation {
    content   = "${each.value.display_name} health check failed, it may be down or unreachable."
    mime_type = "text/markdown"
  }
}

// Email notification channel
resource "google_monitoring_notification_channel" "uptime_notification_channel_email" {
  display_name = "Uptime check notification channel (email)"
  type         = "email"
  labels = {
    email_address = var.uptime_check_notification_email
  }
}

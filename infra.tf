// Kubernetes namespace
resource "kubernetes_namespace" "infra_ns" {
  metadata {
    name = var.infra_namespace
    labels = {
      "name" = var.infra_namespace
    }
  }
}

// Network policy for pods in same namespace
resource "kubernetes_network_policy" "infra_network_policy_same_ns" {
  metadata {
    name      = "allow-same-namespace"
    namespace = kubernetes_namespace.infra_ns.metadata[0].name
  }
  spec {
    policy_types = ["Ingress"]
    pod_selector {
    }
    ingress {
      from {
        pod_selector {
        }
      }
    }
  }
}

// Network policy for ingress nginx
resource "kubernetes_network_policy" "infra_network_policy_ingress_nginx" {
  metadata {
    name      = "allow-ingress-nginx"
    namespace = kubernetes_namespace.infra_ns.metadata[0].name
  }
  spec {
    policy_types = ["Ingress"]
    pod_selector {
    }
    ingress {
      from {
        namespace_selector {
          match_labels = {
            "name" = "ingress-nginx"
          }
        }
      }
    }
  }
}

// Network policy for elastic operator
resource "kubernetes_network_policy" "infra_network_policy_elastic_system" {
  metadata {
    name      = "allow-elastic-system"
    namespace = kubernetes_namespace.infra_ns.metadata[0].name
  }
  spec {
    policy_types = ["Ingress"]
    pod_selector {
    }
    ingress {
      from {
        namespace_selector {
          match_labels = {
            "name" = "elastic-system"
          }
        }
      }
    }
  }
}

// Network policy for elasticsearch
resource "kubernetes_network_policy" "infra_network_policy_elasticsearch" {
  metadata {
    name      = "allow-elasticsearch"
    namespace = kubernetes_namespace.infra_ns.metadata[0].name
  }
  spec {
    policy_types = ["Ingress"]
    pod_selector {
      match_labels = {
        "common.k8s.elastic.co/type" = "elasticsearch"
      }
    }
    ingress {
      from {
        namespace_selector {
        }
      }
    }
  }
}

// APM server
resource "helm_release" "infra_apm" {
  name      = "apm"
  chart     = "${path.module}/infra/charts/apm"
  namespace = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/apm.values.yaml")]
}

// Certificates
resource "helm_release" "infra_certificates" {
  name      = "certificates"
  chart     = "${path.module}/infra/charts/certificates"
  namespace = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/certificates.values.yaml")]
}

// Elasticsearch
resource "helm_release" "infra_elasticsearch" {
  name      = "elasticsearch"
  chart     = "${path.module}/infra/charts/elasticsearch"
  namespace = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/elasticsearch.values.yaml")]
}

// Kibana
resource "helm_release" "infra_kibana" {
  name      = "kibana"
  chart     = "${path.module}/infra/charts/kibana"
  namespace = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/kibana.values.yaml")]
}

// OpenTelemetry Collector Agent
resource "helm_release" "infra_otelcol_agent" {
  name       = "otelcol"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = var.infra_otelcol_version
  namespace  = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/otelcol-agent.values.yaml")]

  depends_on = [kubernetes_secret.infra_otelcol_agent_secret]
}
resource "kubernetes_secret" "infra_otelcol_agent_secret" {
  metadata {
    name      = "otelcol-agent-secret"
    namespace = kubernetes_namespace.infra_ns.metadata[0].name
  }
  type = "Opaque"
  data = {
    MYSQL_MONITORING_USERNAME = var.infra_otelcol_mysql_monitoring_username
    MYSQL_MONITORING_PASSWORD = var.infra_otelcol_mysql_monitoring_password
  }
}
moved {
  from = helm_release.infra_otelcol
  to = helm_release.infra_otelcol_agent
}

// OpenTelemetry Collector Gateway
resource "helm_release" "infra_otelcol_gateway" {
  name       = "otelcol-gateway"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = var.infra_otelcol_version
  namespace  = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/otelcol-gateway.values.yaml")]

  depends_on = [kubernetes_secret.infra_otelcol_gateway_secret]
}
resource "kubernetes_secret" "infra_otelcol_gateway_secret" {
  metadata {
    name      = "otelcol-gateway-secret"
    namespace = kubernetes_namespace.infra_ns.metadata[0].name
  }
  type = "Opaque"
  data = {
    OTELCOL_OTLPHTTP_ENDPOINT = var.infra_otelcol_otlphttp_endpoint
    OTELCOL_OTLPHTTP_USERNAME = var.infra_otelcol_otlphttp_username
    OTELCOL_OTLPHTTP_PASSWORD = var.infra_otelcol_otlphttp_password
  }
}

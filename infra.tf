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

// Network policy for ingress
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

// Network policy for elastic
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

// Backups
resource "helm_release" "infra_backups" {
  name      = "backups"
  chart     = "${path.module}/infra/charts/backups"
  namespace = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/backups.yaml")]

  set_sensitive {
    name  = "secrets.swift.openrc"
    value = var.infra_backups_openrc
  }
  set_sensitive {
    name  = "secrets.gcs.sa"
    value = base64encode(var.infra_backups_sa)
  }
  set_sensitive {
    name  = "secrets.ftp.username"
    value = var.infra_backups_ftp_username
  }
  set_sensitive {
    name  = "secrets.ftp.password"
    value = var.infra_backups_ftp_password
  }
  set_sensitive {
    name  = "secrets.mysql.username"
    value = var.infra_backups_mysql_username
  }
  set_sensitive {
    name  = "secrets.mysql.password"
    value = var.infra_backups_mysql_password
  }
}

// Grafana
resource "helm_release" "infra_grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = var.infra_grafana_version
  namespace  = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/grafana.yaml")]

  set_sensitive {
    name  = "envRenderSecret.GF_DATABASE_PASSWORD"
    value = var.infra_grafana_db_password
  }
}

// Mail server (outbound only)
resource "helm_release" "infra_mailserver" {
  name      = "mailserver"
  chart     = "${path.module}/infra/charts/mailserver"
  namespace = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/mailserver.yaml")]

  set_sensitive {
    name  = "dkim.config.privateKey"
    value = var.infra_mailserver_dkim_private_key
  }
}

// MySQL database
resource "helm_release" "infra_mysql" {
  name      = "mysql"
  chart     = "${path.module}/infra/charts/mysql"
  namespace = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/mysql.yaml")]

  set_sensitive {
    name  = "secrets.root.password"
    value = var.infra_mysql_root_password
  }
}

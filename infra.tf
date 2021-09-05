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

// Elasticsearch
resource "helm_release" "infra_elasticsearch" {
  name      = "elasticsearch"
  chart     = "${path.module}/infra/charts/elasticsearch"
  namespace = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/elasticsearch.yaml")]
}

// Cron jobs
resource "helm_release" "infra_jobs" {
  name      = "jobs"
  chart     = "${path.module}/infra/charts/jobs"
  namespace = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/jobs.yaml")]
}

// Kibana
resource "helm_release" "infra_kibana" {
  name      = "kibana"
  chart     = "${path.module}/infra/charts/kibana"
  namespace = kubernetes_namespace.infra_ns.metadata[0].name

  values = [file("${path.module}/infra/values/kibana.yaml")]
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

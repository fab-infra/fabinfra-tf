// Local storage class
resource "kubernetes_storage_class" "k8s_local_storage" {
  metadata {
    name = "local-storage"
  }
  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"
}

// Admin user service account
resource "kubernetes_service_account" "k8s_admin_user" {
  metadata {
    name      = "admin-user"
    namespace = "kube-system"
  }
  automount_service_account_token = false
}

// Admin user token
resource "kubernetes_secret" "k8s_admin_user_token" {
  metadata {
    name      = "admin-user-token"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.k8s_admin_user.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}

// Admin user cluster role binding
resource "kubernetes_cluster_role_binding" "k8s_admin_user_cluster_role_binding" {
  metadata {
    name = "admin-user"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.k8s_admin_user.metadata[0].name
    namespace = kubernetes_service_account.k8s_admin_user.metadata[0].namespace
  }
}

// Terraform service account
resource "kubernetes_service_account" "k8s_terraform_sa" {
  metadata {
    name      = "terraform"
    namespace = "kube-system"
  }
  automount_service_account_token = false
}

// Terraform token
resource "kubernetes_secret" "k8s_terraform_sa_token" {
  metadata {
    name      = "terraform-token"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.k8s_terraform_sa.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}

// Terraform cluster role binding
resource "kubernetes_cluster_role_binding" "k8s_terraform_sa_cluster_role_binding" {
  metadata {
    name = "terraform"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.k8s_terraform_sa.metadata[0].name
    namespace = kubernetes_service_account.k8s_terraform_sa.metadata[0].namespace
  }
}

// Calico Tigera operator namespace
resource "kubernetes_namespace" "k8s_calico_ns" {
  metadata {
    name = "tigera-operator"
    labels = {
      "name" = "tigera-operator"
    }
  }
}

// Calico Tigera operator
resource "helm_release" "k8s_calico" {
  name       = "calico"
  repository = "https://docs.projectcalico.org/charts"
  chart      = "tigera-operator"
  version    = var.k8s_calico_version
  namespace  = "tigera-operator"

  values = [file("${path.module}/k8s/values/calico.yaml")]
}

// Cert-manager namespace
resource "kubernetes_namespace" "k8s_certmanager_ns" {
  metadata {
    name = "cert-manager"
    labels = {
      "name" = "cert-manager"
    }
  }
}

// Cert-manager
resource "helm_release" "k8s_certmanager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.k8s_certmanager_version
  namespace  = kubernetes_namespace.k8s_certmanager_ns.metadata[0].name

  values = [file("${path.module}/k8s/values/cert-manager.yaml")]
}

// Cert-manager configuratrion
resource "helm_release" "k8s_certmanager_config" {
  name      = "cert-manager-config"
  chart     = "${path.module}/k8s/charts/cert-manager-config"
  namespace = kubernetes_namespace.k8s_certmanager_ns.metadata[0].name

  values = [file("${path.module}/k8s/values/cert-manager-config.yaml")]

  set_sensitive {
    name  = "clusterIssuer.ca.root.crt"
    value = var.k8s_certmanager_root_ca_crt
  }
  set_sensitive {
    name  = "clusterIssuer.ca.root.key"
    value = var.k8s_certmanager_root_ca_key
  }
}

// Dashboard namespace
resource "kubernetes_namespace" "k8s_dashboard_ns" {
  metadata {
    name = "kubernetes-dashboard"
    labels = {
      "name" = "kubernetes-dashboard"
    }
  }
}

// Dashboard
resource "helm_release" "k8s_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  version    = var.k8s_dashboard_version
  namespace  = kubernetes_namespace.k8s_dashboard_ns.metadata[0].name

  values = [file("${path.module}/k8s/values/dashboard.yaml")]
}

// Elastic ECK operator namespace
resource "kubernetes_namespace" "k8s_elastic_operator_ns" {
  metadata {
    name = "elastic-system"
    labels = {
      "name" = "elastic-system"
    }
  }
}

// Elastic ECK operator
resource "helm_release" "k8s_elastic_operator" {
  name       = "elastic-operator"
  repository = "https://helm.elastic.co"
  chart      = "eck-operator"
  version    = var.k8s_elastic_operator_version
  namespace  = kubernetes_namespace.k8s_elastic_operator_ns.metadata[0].name
}

// Ingress Nginx namespace
resource "kubernetes_namespace" "k8s_ingress_nginx_ns" {
  metadata {
    name = "ingress-nginx"
    labels = {
      "name" = "ingress-nginx"
    }
  }
}

// Ingress Nginx OpenTelemetry config
resource "kubernetes_config_map" "k8s_ingress_nginx_otelcol_config" {
  metadata {
    name      = "ingress-nginx-otelcol-config"
    namespace = kubernetes_namespace.k8s_ingress_nginx_ns.metadata[0].name
  }
  data = {
    "config.yaml" : <<-EOF
      receivers:
        prometheus:
          config:
            scrape_configs:
            - job_name: 'ingress-nginx'
              scrape_interval: 10s
              static_configs:
              - targets: ['127.0.0.1:10254']
      processors:
        batch:
      exporters:
        otlp:
          endpoint: $${env:HOST_IP}:4317
          tls:
            insecure: true
      extensions:
        health_check:
      service:
        extensions: [health_check]
        pipelines:
          metrics:
            receivers: [prometheus]
            processors: [batch]
            exporters: [otlp]
      EOF
  }
}

// Ingress Nginx
resource "helm_release" "k8s_ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx/"
  chart      = "ingress-nginx"
  version    = var.k8s_ingress_nginx_version
  namespace  = kubernetes_namespace.k8s_ingress_nginx_ns.metadata[0].name

  values = [file("${path.module}/k8s/values/ingress-nginx.yaml")]

  set {
    name  = "controller.service.externalIPs"
    value = "{${join(",", var.k8s_ingress_nginx_external_ips)}}"
  }
}

// Kubelet CSR Approver
resource "helm_release" "k8s_kubelet_csr_approver" {
  name       = "kubelet-csr-approver"
  repository = "https://postfinance.github.io/kubelet-csr-approver/"
  chart      = "kubelet-csr-approver"
  version    = var.k8s_kubelet_csr_approver_version
  namespace  = "kube-system"
}

// Metrics Server
resource "helm_release" "k8s_metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = var.k8s_metrics_server_version
  namespace  = "kube-system"
}

// OpenEBS namespace
resource "kubernetes_namespace" "k8s_openebs_ns" {
  metadata {
    name = "openebs"
    labels = {
      "name" = "openebs"
    }
  }
}

// OpenEBS
resource "helm_release" "k8s_openebs" {
  name       = "openebs"
  repository = "https://openebs.github.io/charts"
  chart      = "openebs"
  version    = var.k8s_openebs_version
  namespace  = kubernetes_namespace.k8s_openebs_ns.metadata[0].name

  values = [file("${path.module}/k8s/values/openebs.yaml")]
}

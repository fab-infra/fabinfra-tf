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

// Calico Tigera operator
resource "helm_release" "k8s_calico" {
  name      = "calico"
  chart     = "https://github.com/projectcalico/calico/releases/download/v${var.k8s_calico_version}/tigera-operator-v3.19.1-1.tgz"
  namespace = "kube-system"

  values = [file("${path.module}/k8s/values/calico.yaml")]
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

// Ingress Nginx namespace
resource "kubernetes_namespace" "k8s_ingress_nginx_ns" {
  metadata {
    name = "ingress-nginx"
    labels = {
      "name" = "ingress-nginx"
    }
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
}

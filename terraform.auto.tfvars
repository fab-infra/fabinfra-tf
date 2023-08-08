# OVH provider
ovh_endpoint = "ovh-eu"
#ovh_application_key = "toComplete"
#ovh_application_secret = "toComplete"
#ovh_consumer_key = "toComplete"

# GCP provider
#gcp_credentials = "toComplete"
gcp_project_id = "fabinfra-net"
gcp_region = "europe-west1"
gcp_billing_notification_email = "webmaster@fabinfra.net"

# Grafana provider
grafana_url = "https://fabinfra.grafana.net/"
#grafana_auth = "toComplete"
grafana_sm_url = "https://synthetic-monitoring-api.grafana.net"
#grafana_sm_access_token = "toComplete"

# Kubernetes provider
k8s_host = "https://k8s-master.fabinfra.net:6443"
#k8s_client_cert = "toComplete"
#k8s_client_key = "toComplete"
#k8s_ca_cert = "toComplete"

# Kubernetes config
k8s_calico_version = "v3.23.5"
k8s_certmanager_version = "v1.10.1"
# k8s_certmanager_root_ca_crt = "toComplete"
# k8s_certmanager_root_ca_key = "toComplete"
k8s_dashboard_version = "5.10.0"
k8s_elastic_operator_version = "2.9.0"
k8s_ingress_nginx_version = "4.2.5"
k8s_ingress_nginx_external_ips = ["5.39.85.118"]

# DNS records
dns_zone = "fabinfra.net"
dns_records = [
  { name = "",                      ttl = 1800,  type = "A",      target = "5.39.85.118" },
  { name = "",                      ttl = 1800,  type = "AAAA",   target = "2001:41d0:8:9776::1" },
  { name = "",                      ttl = 3600,  type = "CAA",    target = "128 issue \"letsencrypt.org\"" },
  { name = "",                      ttl = 3600,  type = "MX",     target = "1 mx4.mail.ovh.net." },
  { name = "",                      ttl = 3600,  type = "MX",     target = "10 mx3.mail.ovh.net." },
  { name = "",                      ttl = 600,   type = "SPF",    target = "\"v=spf1 a:ks13.srv.fabinfra.net include:mx.ovh.com ?all\"" },
  { name = "",                      ttl = 300,   type = "TXT",    target = "\"google-site-verification=mzVqztJJ7oLUjOvVqbTzLWAspa6kfCn8nZ2DUHSsIug\"" },
  { name = "",                      ttl = 300,   type = "TXT",    target = "\"google-site-verification=VuA2XEeHY7Zyt31h9kZ4J6iwat6NrQFDowZr5JmKjQg\"" },
  { name = "_dmarc",                ttl = 600,   type = "DMARC",  target = "v=DMARC1;p=none;rua=mailto:postmaster@fabinfra.net;" },
  { name = "ip",                    ttl = 3600,  type = "NS",     target = "ns-aws.nono.io." },
  { name = "ip",                    ttl = 3600,  type = "NS",     target = "ns-gce.nono.io." },
  { name = "ipv4.ks13.srv",         ttl = 3600,  type = "A",      target = "5.39.85.118" },
  { name = "ipv6.ks13.srv",         ttl = 3600,  type = "AAAA",   target = "2001:41d0:8:9776::1" },
  { name = "k8s",                   ttl = 1800,  type = "CNAME",  target = "k8s-ingress" },
  { name = "k8s-ingress",           ttl = 1800,  type = "CNAME",  target = "ipv4.ks13.srv" },
  { name = "k8s-master",            ttl = 1800,  type = "CNAME",  target = "ipv4.ks13.srv" },
  { name = "k8s-master.vpn",        ttl = 1800,  type = "CNAME",  target = "ks13.vpn" },
  { name = "kibana",                ttl = 1800,  type = "CNAME",  target = "k8s-ingress" },
  { name = "ks13.srv",              ttl = 3600,  type = "A",      target = "5.39.85.118" },
  { name = "ks13.srv",              ttl = 3600,  type = "AAAA",   target = "2001:41d0:8:9776::1" },
  { name = "ks13.srv",              ttl = 600,   type = "SPF",    target = "\"v=spf1 a -all\"" },
  { name = "ks13.vpn",              ttl = 3600,  type = "A",      target = "10.8.2.1" },
  { name = "march2016._domainkey",  ttl = 3600,  type = "DKIM",   target = "k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwvjrMuYA4hkI0TMzk6h4Hec06Unn/qZUxf4YnR5OWkCYrlIJZXuOUIsYZMXTiXCEhPdO6JktOcdVcUyB8UdhGLv7PoMShG+Kb9zsfqOtLJ3dfzJuaBsoV0BEi4yLqXPTNqbzE4YtxynC11MfPrtxwIYmJ5p4S2RMztBTZC5g/1PoQ2UWk/NphEzO6iA4Bbtas1OD+44Moa1OYMbi3YZrmEn1WTfrWodunAYE92Usoj+kpSiBqhYPS/r8iQMOsRZOznDZhxG7VIYGU5xq+Ah0hpWoU/Nvs79LBP0pgC7vyCRXec18Q7Ix3t7WaYOZv5/GfhbcWREM0wVAsEQYjVp9cwIDAQAB;t=s;" },
  { name = "od01.srv",              ttl = 3600,  type = "A",      target = "192.168.0.122" },
  { name = "od01.vpn",              ttl = 3600,  type = "A",      target = "10.8.2.126" },
  { name = "proxy.vpn",             ttl = 1800,  type = "CNAME",  target = "ks13.vpn" },
  { name = "rb04.srv",              ttl = 3600,  type = "A",      target = "192.168.0.121" },
  { name = "rb04.vpn",              ttl = 3600,  type = "A",      target = "10.8.2.122" },
  { name = "vpn",                   ttl = 1800,  type = "CNAME",  target = "ks13.srv" },
]

# Infra
infra_namespace = "infra"
#infra_promtail_loki_address = "toComplete"
infra_promtail_version = "3.11.0"

# Uptime checks
uptime_check_urls = [
 "https://k8s.fabinfra.net/",
 "https://kibana.fabinfra.net/login",
]

# VPN
vpn_machine_type = "e2-micro"
vpn_zones = ["us-east1-c"]
#vpn_cacert = "toComplete"
#vpn_servercert = "toComplete"
#vpn_serverkey = "toComplete"

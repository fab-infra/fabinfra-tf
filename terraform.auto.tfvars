# OVH provider
ovh_endpoint = "ovh-eu"
#ovh_application_key = "toComplete"
#ovh_application_secret = "toComplete"
#ovh_consumer_key = "toComplete"

# GCP provider
#gcp_credentials = "toComplete"
gcp_project_id = "fabinfra-net"
gcp_region = "europe-west1"

# DNS records
dns_zone = "fabinfra.net"
dns_records = [
  { name = "",                      ttl = 0,     type = "A",      target = "5.39.85.174" },
  { name = "",                      ttl = 0,     type = "AAAA",   target = "2001:41d0:8:97ae::1" },
  { name = "",                      ttl = 0,     type = "CAA",    target = "128 issue \"letsencrypt.org\"" },
  { name = "",                      ttl = 0,     type = "MX",     target = "1 mx4.mail.ovh.net." },
  { name = "",                      ttl = 0,     type = "MX",     target = "10 mx3.mail.ovh.net." },
  { name = "",                      ttl = 600,   type = "SPF",    target = "\"v=spf1 a:ks11.srv.fabinfra.net a:sy02.srv.fabinfra.net include:mx.ovh.com ?all\"" },
  { name = "",                      ttl = 0,     type = "TXT",    target = "\"google-site-verification=mzVqztJJ7oLUjOvVqbTzLWAspa6kfCn8nZ2DUHSsIug\"" },
  { name = "grafana",               ttl = 1800,  type = "CNAME",  target = "k8s" },
  { name = "hs11.srv",              ttl = 0,     type = "A",      target = "192.168.0.105" },
  { name = "hs12.srv",              ttl = 0,     type = "A",      target = "192.168.0.101" },
  { name = "ip",                    ttl = 0,     type = "NS",     target = "ns-aws.nono.io." },
  { name = "ip",                    ttl = 0,     type = "NS",     target = "ns-gce.nono.io." },
  { name = "ipv4.ks11.srv",         ttl = 0,     type = "A",      target = "37.187.118.231" },
  { name = "ipv4.sy02.srv",         ttl = 0,     type = "A",      target = "5.39.85.174" },
  { name = "ipv6.ks11.srv",         ttl = 0,     type = "AAAA",   target = "2001:41d0:a:6be7::1" },
  { name = "ipv6.sy02.srv",         ttl = 0,     type = "AAAA",   target = "2001:41d0:8:97ae::1" },
  { name = "k8s",                   ttl = 1800,  type = "CNAME",  target = "sy02.srv" },
  { name = "k8s-master",            ttl = 1800,  type = "CNAME",  target = "sy02.srv" },
  { name = "k8s-master.vpn",        ttl = 1800,  type = "CNAME",  target = "sy02.vpn" },
  { name = "kibana",                ttl = 1800,  type = "CNAME",  target = "k8s" },
  { name = "ks11.srv",              ttl = 0,     type = "A",      target = "37.187.118.231" },
  { name = "ks11.srv",              ttl = 0,     type = "AAAA",   target = "2001:41d0:a:6be7::1" },
  { name = "ks11.srv",              ttl = 600,   type = "SPF",    target = "\"v=spf1 a -all\"" },
  { name = "ks11.vpn",              ttl = 0,     type = "A",      target = "10.8.2.1" },
  { name = "march2016._domainkey",  ttl = 0,     type = "DKIM",   target = "k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwvjrMuYA4hkI0TMzk6h4Hec06Unn/qZUxf4YnR5OWkCYrlIJZXuOUIsYZMXTiXCEhPdO6JktOcdVcUyB8UdhGLv7PoMShG+Kb9zsfqOtLJ3dfzJuaBsoV0BEi4yLqXPTNqbzE4YtxynC11MfPrtxwIYmJ5p4S2RMztBTZC5g/1PoQ2UWk/NphEzO6iA4Bbtas1OD+44Moa1OYMbi3YZrmEn1WTfrWodunAYE92Usoj+kpSiBqhYPS/r8iQMOsRZOznDZhxG7VIYGU5xq+Ah0hpWoU/Nvs79LBP0pgC7vyCRXec18Q7Ix3t7WaYOZv5/GfhbcWREM0wVAsEQYjVp9cwIDAQAB;t=s;" },
  { name = "proxy",                 ttl = 1800,  type = "CNAME",  target = "ks11.srv" },
  { name = "proxy.vpn",             ttl = 1800,  type = "CNAME",  target = "ks11.vpn" },
  { name = "rb02.vpn",              ttl = 0,     type = "A",      target = "10.8.2.126" },
  { name = "rb04.srv",              ttl = 0,     type = "A",      target = "192.168.0.121" },
  { name = "rb04.vpn",              ttl = 0,     type = "A",      target = "10.8.2.122" },
  { name = "sy02.srv",              ttl = 0,     type = "A",      target = "5.39.85.174" },
  { name = "sy02.srv",              ttl = 0,     type = "AAAA",   target = "2001:41d0:8:97ae::1" },
  { name = "sy02.srv",              ttl = 600,   type = "SPF",    target = "\"v=spf1 a -all\"" },
  { name = "sy02.vpn",              ttl = 0,     type = "A",      target = "10.8.2.114" },
  { name = "vpn",                   ttl = 1800,  type = "CNAME",  target = "ks11.srv" },
]

# Uptime checks
uptime_check_urls = [
  "https://grafana.fabinfra.net/login",
  "https://k8s.fabinfra.net/",
  "https://kibana.fabinfra.net/login",
]

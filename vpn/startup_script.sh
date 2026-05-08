#!/bin/bash

# Install monitoring agent
curl -sS https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh | bash -s -- --also-install

# Install packages
apt-get -q update
DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends firewalld nftables openvpn

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-custom.conf
sysctl -p --system

# Start and configure firewall
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --zone=public --add-interface=eth0
firewall-cmd --permanent --zone=public --add-interface=ens4
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --permanent --zone=public --add-port=1194/tcp
firewall-cmd --permanent --zone=public --add-forward-port=port=443:proto=tcp:toport=1194
firewall-cmd --permanent --new-zone=vpn
firewall-cmd --permanent --zone=vpn --add-interface=tun0
firewall-cmd --permanent --new-zone=default
firewall-cmd --permanent --new-policy=vpn-clients
firewall-cmd --permanent --policy=vpn-clients --add-ingress-zone=vpn
firewall-cmd --permanent --policy=vpn-clients --add-egress-zone=public
firewall-cmd --permanent --policy=vpn-clients --set-target=ACCEPT
firewall-cmd --permanent --policy=vpn-clients --add-masquerade
firewall-cmd --reload
firewall-cmd --set-default-zone=default

# Configure OpenVPN
cp /usr/share/doc/openvpn/examples/sample-keys/dh2048.pem /etc/openvpn/server/dh2048.pem
gcloud secrets versions access latest --secret="${cacert_secret_id}" > "/etc/openvpn/server/cacert.pem"
gcloud secrets versions access latest --secret="${servercert_secret_id}" > "/etc/openvpn/server/servercert.pem"
gcloud secrets versions access latest --secret="${serverkey_secret_id}" > "/etc/openvpn/server/serverkey.pem"
cat <<EOF > /etc/openvpn/server/server.conf
port 1194
proto tcp-server
mode server
tls-server
dev tun
max-clients 10
duplicate-cn
server 10.8.3.0 255.255.255.0
ca cacert.pem
cert servercert.pem
key serverkey.pem
dh dh2048.pem
keepalive 10 120
comp-lzo
verb 4
mute 10
EOF

# Start OpenVPN
systemctl enable openvpn-server@server.service
systemctl restart openvpn-server@server.service

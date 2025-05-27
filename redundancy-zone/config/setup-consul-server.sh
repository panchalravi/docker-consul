#!/bin/sh

mkdir -p /etc/consul.d
mkdir -p /opt/consul/data
cp /config/license.hclic /etc/consul.d/license.hclic

# Create Vault agent configuration file
cat << EOF | tee "/etc/consul.d/consul.hcl" 
server = true
datacenter = "$DATACENTER"
bootstrap_expect = $BOOTSTRAP_EXPECT
data_dir = "/opt/consul/data"
node_name = "server-$SERVER_NUMBER"
retry_join = ["consul-server-1", "consul-server-2", "consul-server-3", "consul-server-4", "consul-server-5","consul-server-6"]
bind_addr = "0.0.0.0"
advertise_addr = "$(hostname -i)"
client_addr = "0.0.0.0"


license_path = "/etc/consul.d/license.hclic"
ports {
  http = 8500
  grpc = 8502
}
node_meta {
  zone = "$ZONE"
}
autopilot {
  redundancy_zone_tag = "zone"
}
ui_config {
  enabled = true
}
acl {
  enabled = false
}
log_level = "INFO"
EOF

exec consul agent -config-dir=/etc/consul.d
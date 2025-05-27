#!/bin/sh

mkdir -p /etc/consul.d
mkdir -p /opt/consul/data
# cp /config/license.hclic /etc/consul.d/license.hclic

echo $LICENSE > "/etc/consul.d/license.hclic"


# Create Vault agent configuration file
cat << EOF | tee "/etc/consul.d/consul.hcl" 
server = true
datacenter = "$DATACENTER"
bootstrap_expect = $BOOTSTRAP_EXPECT
data_dir = "/opt/consul/data"
node_name = "consul-server-$SERVER_NUMBER"
# retry_join = ["consul-server-1", "consul-server-2", "consul-server-3"]
retry_join = ["consul-server-1"]
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"
advertise_addr = "{{ GetInterfaceIP \"eth0\" }}"
client_addr = "0.0.0.0"


license_path = "/etc/consul.d/license.hclic"
ports {
  http = 8500
  grpc = 8502
}
ui_config {
  enabled = true
}
acl {
  enabled = false
}
connect {
  enabled = true
}
log_level = "INFO"
EOF

exec consul agent -config-dir=/etc/consul.d
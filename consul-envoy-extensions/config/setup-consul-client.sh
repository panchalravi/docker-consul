#!/bin/sh

mkdir -p /etc/consul.d
mkdir -p /opt/consul/data
cp /config/license.hclic /etc/consul.d/license.hclic

# Create Vault agent configuration file
cat << EOF | tee "/etc/consul.d/consul.hcl" 
server = false
datacenter = "$DATACENTER"
data_dir = "/opt/consul/data"
node_name = "$NODE_NAME"
retry_join = ["consul-server-1"]
bind_addr = "0.0.0.0"
advertise_addr = "$(hostname -i)"
client_addr = "0.0.0.0"


license_path = "/etc/consul.d/license.hclic"
ports {
  grpc = 8502
}
acl {
  enabled = false
}
connect {
  enabled = true
}
log_level = "INFO"
EOF

if [ -n "$SERVICE_CONFIG_FILE" ]; then
    exec consul agent -config-dir=/etc/consul.d -config-file=$SERVICE_CONFIG_FILE
else
    exec consul agent -config-dir=/etc/consul.d
fi

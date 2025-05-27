#!/bin/sh

mkdir -p /etc/consul.d
mkdir -p /opt/consul/data

echo $LICENSE > "/etc/consul.d/license.hclic"


# Create Consul agent configuration file
cat << EOF | tee "/etc/consul.d/consul.hcl" 
server = false
datacenter = "$DATACENTER"
data_dir = "/opt/consul/data"
node_name = "$NODE_NAME"
retry_join = ["${CONSUL_SERVERS}"]
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"
advertise_addr = "{{ GetInterfaceIP \"eth0\" }}"
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

#!/bin/sh

mkdir -p /etc/consul.d
mkdir -p /opt/consul/data
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
bind_addr = "0.0.0.0"
advertise_addr = "$(hostname -i)"
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
  enabled = true
  default_policy = "deny"
  down_policy = "extend-cache"
  enable_token_persistence = true
  tokens {
    initial_management = "$CONSUL_MANAGEMENT_TOKEN"
    agent = "$CONSUL_MANAGEMENT_TOKEN"
  }
}
connect {
  enabled = true
}
log_level = "INFO"
EOF

exec consul agent -config-dir=/etc/consul.d
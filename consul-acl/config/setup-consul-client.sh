#!/bin/sh

mkdir -p /etc/consul.d
mkdir -p /opt/consul/data
# Write the license key to a file
echo $LICENSE > "/etc/consul.d/license.hclic"

# Generate agent token
export CONSUL_HTTP_ADDR="http://consul-server-1:8500"
export CONSUL_HTTP_TOKEN=$CONSUL_MANAGEMENT_TOKEN
# AGENT_TOKEN=$(consul acl token create -node-identity "$NODE_NAME:$DATACENTER" -format json | jq -r .SecretID)

if [ -n "$GATEWAY_TYPE" ]; then
    consul acl policy create -name "mesh-read" -rules 'partition "default" { mesh  = "read" }' -format json > /dev/null
    AGENT_TOKEN=$(consul acl token create -node-identity "$NODE_NAME:$DATACENTER" -service-identity "$SERVICE_NAME" -policy-name "mesh-read" -format json | jq -r .SecretID)
else
    AGENT_TOKEN=$(consul acl token create -node-identity "$NODE_NAME:$DATACENTER" -format json | jq -r .SecretID)
fi

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
  default_policy = "deny"
  down_policy = "extend-cache"
  enable_token_persistence = true
  tokens {
    agent = "$AGENT_TOKEN"
    default = "$AGENT_TOKEN"
  }
}
connect {
  enabled = true
}
log_level = "INFO"
EOF


if [ -n "$SERVICE_CONFIG_FILE" ]; then
    SERVICE_TOKEN=$(consul acl token create -service-identity "$SERVICE_NAME" -format json | jq -r .SecretID)
    sed -i 's/token = "[^"]*"/token = "'"$SERVICE_TOKEN"'"/' $SERVICE_CONFIG_FILE
    exec consul agent -config-dir=/etc/consul.d -config-file=$SERVICE_CONFIG_FILE
else
    exec consul agent -config-dir=/etc/consul.d
fi

#!/bin/sh

mkdir -p /etc/consul.d
mkdir -p /opt/consul/data


LOG_LEVEL="info"
ADMIN_PARTITION="default"

if [ -n "$LOG_LEVEL" ]; then
    LOG_LEVEL="$LOG_LEVEL"
fi

if [ -n "$PARTITION" ]; then
    ADMIN_PARTITION="$PARTITION"
fi

# Function to check if partition exists
check_partition() {
    partition_name=$1
    consul partition list -http-addr="consul-server-dc1:8500" -format=json 2>/dev/null | jq -e ".[] | select(.Name == \"$partition_name\")" > /dev/null
    return $?
}

# Check and create partition if it doesn't exist (skip for default partition)
if [ "$ADMIN_PARTITION" != "default" ]; then
    if ! check_partition "$ADMIN_PARTITION"; then
        echo "Creating admin partition: $ADMIN_PARTITION"
        consul partition create -http-addr="consul-server-dc1:8500" -name="$ADMIN_PARTITION" || {
            echo "Failed to create admin partition"
            exit 1
        }
    else
        echo "Admin partition '$ADMIN_PARTITION' already exists"
    fi
fi

# Write the license key to a file
echo $LICENSE > "/etc/consul.d/license.hclic"

# Create Vault agent configuration file
cat << EOF | tee "/etc/consul.d/consul.hcl" 
server = false
datacenter = "$DATACENTER"
partition = "$ADMIN_PARTITION"
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

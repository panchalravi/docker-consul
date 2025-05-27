#/bin/bash
export CONSUL_DC1=http://localhost:8500
# export CONSUL_DC2=http://localhost:9500

export DEFAULT_PARTITION="default"
export FINANCE_PARTITION="finance"

# Configure peering through mesh-gateway
# consul config write -http-addr=$CONSUL_DC1 ./service_config/mesh.hcl
# consul config write -http-addr=$CONSUL_DC2 ./service_config/mesh.hcl
consul config write -http-addr=$CONSUL_DC1 -partition $DEFAULT_PARTITION ./service_config/proxy-defaults.hcl
consul config write -http-addr=$CONSUL_DC1 -partition $FINANCE_PARTITION ./service_config/proxy-defaults.hcl
# consul config write -http-addr=$CONSUL_DC2 ./service_config/proxy-defaults.hcl


# consul config read -http-addr=$CONSUL_DC1 -kind mesh -name mesh
# consul config read -http-addr=$CONSUL_DC2 -kind mesh -name mesh

# Establish peering between datacenters
# export PEERING_TOKEN=$(consul peering generate-token -http-addr=$CONSUL_DC1 -name dc2-default)
# consul peering establish -http-addr=$CONSUL_DC2 -name dc1-default -peering-token $PEERING_TOKEN

# Export services from DC2 to DC1
consul config write -http-addr=$CONSUL_DC1 -partition=$FINANCE_PARTITION ./service_config/exported-services-finance.hcl

# Write configs
# consul config write -http-addr=$CONSUL_DC1 ./service_config/api-v1-service-resolver.hcl
consul config write -http-addr=$CONSUL_DC1 -partition=$DEFAULT_PARTITION ./service_config/api-gw-listener.hcl
consul config write -http-addr=$CONSUL_DC1 -partition=$DEFAULT_PARTITION ./service_config/api-gw-route.hcl
# consul config read -http-addr=$CONSUL_DC1 -kind service-resolver -name api

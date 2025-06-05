#!/bin/sh

export CONSUL_HTTP_ADDR="http://consul-server-1:8500"
export CONSUL_HTTP_TOKEN=$CONSUL_MANAGEMENT_TOKEN

# consul acl token create -service-identity "$SERVICE_NAME" -format json > /tmp/token.json 

if [ -n "$GATEWAY_TYPE" ]; then
    # consul acl policy create -name "mesh-read" -rules 'partition "default" { mesh  = "read" }' -format json > /dev/null
    consul acl token create -service-identity "$SERVICE_NAME" -policy-name "mesh-read" > /tmp/token.json
else
    consul acl token create -service-identity "$SERVICE_NAME" > /tmp/token.json
fi

export CONSUL_HTTP_ADDR="http://localhost:8500"
export CONSUL_HTTP_TOKEN=$(cat /tmp/token.json | jq -r '.SecretID')

if [ -n "$GATEWAY_TYPE" ]; then
    exec consul connect envoy -gateway $GATEWAY_TYPE -register -service $SERVICE_NAME
else
    exec consul connect envoy -sidecar-for $SERVICE_NAME
fi
#!/bin/bash

export CONSUL_HTTP_ADDR="http://localhost:8500"
export CONSUL_HTTP_TOKEN=$(cat .env | grep -i token | awk -F'=' '{print $2}')

consul config write ./service_config/proxy-defaults.hcl
consul config write ./service_config/api-gw-listener.hcl
consul config write ./service_config/api-gw-route.hcl

# Create intentions
consul intention create gateway-api web 
consul intention create web api 

#!/bin/bash

consul config write ./service_config/proxy-defaults.hcl
consul config write ./service_config/api-gw-listener.hcl
consul config write ./service_config/api-gw-route.hcl


# Run below commands to simulate API Gateway response override for 5xx errors
consul config write ./service_config/api-gw-5xx.hcl
consul config write ./service_config/api-gw-lua.hcl


# consul config write ./service_config/web-lua.hcl
# consul config read -kind=http-route -name=web-http-route
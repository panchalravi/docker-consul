#!/bin/bash

consul config write ./service_config/proxy-defaults.hcl
consul config write ./service_config/api-gw-listener.hcl
consul config write ./service_config/api-gw-route.hcl
consul config write ./service_config/web-lua.hcl


consul config read -kind=http-route -name=web-http-route
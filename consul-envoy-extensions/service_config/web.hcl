# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

service {
  name = "web"
  id = "web"
  port = 9092

  tags = ["v1"]
  meta = {
    version = "1"
  }

  check {
    name = "Web Service Check"
    http = "http://localhost:9092/health"
    interval = "10s"
    timeout = "1s"
  }

  connect {
    sidecar_service {
      port = 20000
      check {
        name = "Connect Envoy Sidecar"
        tcp = "localhost:20000"
        interval = "10s"
      }
      proxy {
        upstreams = [{
          destination_name = "api"
          local_bind_address = "127.0.0.1"
          local_bind_port  = 8181
        },
        {
          destination_name = "api-v2"
          local_bind_address = "127.0.0.1"
          local_bind_port  = 8182
        }]
      }
    }
  }
}
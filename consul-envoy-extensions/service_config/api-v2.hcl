# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

service {
  name = "api-v2"
  id = "api-v2"
  port = 9092

  tags = ["v2"]
  meta = {
    version = "2"
  }

  check {
    name = "API Service Check"
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
    }
  }
}
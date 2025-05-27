# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

service {
  name = "api"
  id = "api-v1"
  port = 9092

  tags = ["v1"]
  meta = {
    version = "1"
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
#!/bin/bash
find . -type f -name '*.yml' -exec sed -i 's/nicholasjackson\/fake-service:v0.26.2/panchalravi\/fake-service:s390x/g' {} +
find . -type f -name '*.yml' -exec sed -i 's/panchalravi\/consul-envoy:latest/panchalravi\/consul-envoy:s390x/g' {} +
find . -type f -name '*.yml' -exec sed -i 's/hashicorp\/consul-enterprise:latest/panchalravi\/consul-envoy:s390x/g' {} +
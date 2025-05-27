### CONFIGURATION ###
#
# These default values can be used by a Github Action to build images, if enabled.
#
ARG ENVOY_IMAGE=envoyproxy/envoy:v1.31-latest
ARG CONSUL_IMAGE=hashicorp/consul-enterprise:1.21-ent

#
### END CONFIGURATION ###

FROM ${ENVOY_IMAGE} AS envoy-bin

FROM ${CONSUL_IMAGE} AS consul-bin

FROM ubuntu AS base

RUN apt-get update && \
    apt-get install -y \
      bash \
      curl \
      jq  \
      net-tools \
      dnsutils \
      vim \
      iputils-ping \
    && rm -rf /var/lib/apt/lists/*

COPY --from=envoy-bin /usr/local/bin/envoy /bin/envoy
COPY --from=consul-bin /bin/consul /bin/consul

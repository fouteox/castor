FROM php:8.4-cli-alpine

RUN apk add --no-cache \
  curl \
  bash

ARG TARGETPLATFORM

RUN printf '#!/bin/sh\ntrap "exit 0" INT TERM\nexec castor "$@"' > /usr/local/bin/docker-entrypoint.sh && \
  chmod +x /usr/local/bin/docker-entrypoint.sh

RUN case "${TARGETPLATFORM}" in \
  "linux/amd64") CASTOR_ARCH="linux-amd64" ;; \
  "linux/arm64") CASTOR_ARCH="linux-arm64" ;; \
  "linux/arm/v7") CASTOR_ARCH="linux-arm64" ;; \
  *) echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1 ;; \
  esac && \
  curl -L "https://github.com/jolicode/castor/releases/latest/download/castor.${CASTOR_ARCH}.phar" -o /usr/local/bin/castor && \
  chmod +x /usr/local/bin/castor

WORKDIR /app

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

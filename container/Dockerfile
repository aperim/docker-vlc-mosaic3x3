ARG OS_CONTAINER=debian
ARG OS_VARIENT=latest
FROM ghcr.io/aperim/vlc-${OS_CONTAINER}-${OS_VARIENT}:1

HEALTHCHECK \
    --interval=1m \
    --timeout=3s \
    --start-period=30s \
    --retries=3 \
    CMD pidof vlc > /dev/null || exit 1

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ffmpeg \
  imagemagick \
  mpg123 \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY rootfs/ /

WORKDIR /vlc

USER vlc

CMD ["/usr/local/sbin/mosaic"]

ARG BUILD_DATE
ARG BUILD_NAME
ARG BUILD_DESCRIPTION
ARG BUILD_VENDOR
ARG BUILD_REPOSITORY
ARG BUILD_REF
ARG BUILD_VERSION

LABEL \
    maintainer="Troy Kelly <troy@aperim.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="${BUILD_VENDOR}" \
    org.opencontainers.image.authors="Troy Kelly <troy@aperim.com>" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.url="https://aperim.com" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
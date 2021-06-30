FROM debian:latest
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG PORT=4212
ARG RC_PORT=5212
ENV PORT=${PORT}
ENV VLC_RC_PORT=${RC_PORT}

LABEL org.opencontainers.image.source https://github.com/aperim/docker-vlc-multicast
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="VLC to 3x3 Mosaic" \
  org.label-schema.description="Generate and multicast a 3x3 Mosaic" \
  org.label-schema.url="https://github.com/aperim/docker-vlc-mosaic3x3" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/aperim/docker-vlc-mosaic3x3" \
  org.label-schema.vendor="Aperim Pty Ltd" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

EXPOSE ${PORT}

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install vlc ffmpeg mpg123 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN addgroup --gid 1001 vlc && \
  adduser --home /vlc --gecos "VLC User" --shell /sbin/nologin --uid 1001 --gid 1001 --disabled-password --disabled-login vlc

WORKDIR /vlc

COPY --chown=vlc:vlc ./start.sh ./

USER vlc

ENTRYPOINT ./start.sh

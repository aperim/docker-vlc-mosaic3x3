FROM alpine:latest
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG PORT=4212
ENV PORT=${PORT}

LABEL org.opencontainers.image.source https://github.com/aperim/docker-vlc-mosaic3x3
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

RUN apk --no-cache add vlc imagemagick

RUN adduser -h /vlc -g "VLC User" -s /sbin/nologin -D vlc vlc

WORKDIR /vlc

COPY --chown=vlc:vlc ./start.sh ./

USER vlc

ENTRYPOINT ./start.sh

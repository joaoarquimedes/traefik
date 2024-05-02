ARG ARCH=${ARCH}
FROM --platform=${ARCH} alpine:latest
LABEL autor="Joao Arquimedes"

RUN apk update
RUN apk upgrade
RUN apk add logrotate gzip

COPY --chown=root.root --chmod=600 ./conf/logrotate.d/traefik /etc/logrotate.d/traefik

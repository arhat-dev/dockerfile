FROM golang:1.16-alpine3.12

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY scripts/go/alpine-base-setup.sh /setup.sh
RUN sh /setup.sh && rm /setup.sh

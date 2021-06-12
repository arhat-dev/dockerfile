ARG TARGET=yamllint
ARG ARCH=amd64

FROM ghcr.io/arhat-dev/builder-python3.7:alpine-${ARCH} as builder
FROM ghcr.io/arhat-dev/python3.7:alpine-${ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

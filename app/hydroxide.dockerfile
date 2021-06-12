ARG ARCH=amd64

FROM ghcr.io/arhat-dev/builder-go:alpine AS builder
FROM ghcr.io/arhat-dev/go:alpine-${ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ENTRYPOINT [ "/hydroxide" ]

ARG ARCH=amd64

FROM ghcr.io/arhat-dev/builder-go:alpine AS builder
FROM ghcr.io/arhat-dev/go:alpine-${ARCH}

ENTRYPOINT [ "/hydroxide" ]

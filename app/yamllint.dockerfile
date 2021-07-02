ARG ARCH=amd64

FROM ghcr.io/arhat-dev/builder-python3.7:alpine-${ARCH} as builder
COPY . /app
RUN /build.sh

FROM ghcr.io/arhat-dev/python3.7:alpine-${ARCH}
COPY --from=builder /app /app

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

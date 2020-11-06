ARG ARCH=amd64
# docker flavored arch name
ARG DOCKER_ARCH=amd64

FROM ghcr.io/arhat-dev/builder-rust:debian as builder
FROM ${DOCKER_ARCH}/alpine:3.11

ONBUILD ARG TARGET
ONBUILD ARG APP=${TARGET}
ONBUILD COPY --from=builder /app/build/${TARGET} /${APP}

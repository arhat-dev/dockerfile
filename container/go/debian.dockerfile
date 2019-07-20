ARG ARCH=amd64
# docker flavored arch name
ARG DOCKER_ARCH=amd64

FROM arhatdev/builder-go:debian as builder
FROM ${DOCKER_ARCH}/debian:stretch-slim

ONBUILD ARG TARGET
ONBUILD COPY --from=builder /app/build/${TARGET} /app

# set OCI default command
ENTRYPOINT [ "/app" ]

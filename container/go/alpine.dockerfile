ARG ARCH=amd64
# docker flavored arch name
ARG DOCKER_ARCH=amd64

# to make sure application is linked against musl-libc when cgo was used, only
# alpine based builder is valid here
FROM arhatdev/builder-go:alpine as builder
FROM ${DOCKER_ARCH}/alpine:latest

ONBUILD ARG TARGET
ONBUILD COPY --from=builder /app/build/${TARGET} /${TARGET}
ONBUILD ENTRYPOINT [ "/${TARGET}" ]

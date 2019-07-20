# use native build to make sure qemu executable
FROM alpine:latest as downloader

ARG QEMU_VERSION

RUN wget --quiet -O /qemu-arm-static \
    https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_VERSION}/qemu-arm-static ;\
    chmod +x /qemu-arm-static

FROM arm32v7/golang:alpine

# add qemu for cross build
COPY --from=downloader /qemu-arm-static  \
    /usr/bin/qemu-arm-static

# install dependencies
RUN apk --no-cache add \
      ca-certificates wget build-base curl git make upx ;

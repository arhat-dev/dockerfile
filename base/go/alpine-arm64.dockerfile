# use native build to make sure qemu executable
FROM alpine:latest as downloader

RUN wget --quiet -O /qemu-aarch64-static \
    https://github.com/multiarch/qemu-user-static/releases/download/v4.0.0-5/qemu-aarch64-static ;\
    chmod +x /qemu-aarch64-static

FROM arm64v8/golang:alpine

# add qemu for cross build
COPY --from=downloader /qemu-aarch64-static  \
    /usr/bin/qemu-aarch64-static

# install dependencies
RUN apk --no-cache add \
      ca-certificates wget build-base curl git make upx ;

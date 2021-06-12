# use native build to make sure qemu executable
FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu armv7

FROM arm32v7/python:3.8-alpine3.12

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

# add qemu for cross build
COPY --from=downloader /qemu* /usr/bin/

# install build tools
RUN apk --no-cache add ca-certificates wget build-base curl ;\
    pip3 install pipenv ;

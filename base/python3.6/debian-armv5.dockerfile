FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu armv5

FROM arm32v5/python:3.6-buster

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

# add qemu for cross build
COPY --from=downloader /qemu* /usr/bin/

# install build tools
RUN apt-get update ;\
    apt-get install -y wget build-essential curl ;\
    pip3 install pipenv ;

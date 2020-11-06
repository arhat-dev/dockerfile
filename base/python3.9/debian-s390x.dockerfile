FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu s390x

FROM s390x/python:3.9-buster

# add qemu for cross build
COPY --from=downloader /qemu* /usr/bin/

# install build tools
RUN apt-get update ;\
    apt-get install -y wget build-essential curl ;\
    pip3 install pipenv ;

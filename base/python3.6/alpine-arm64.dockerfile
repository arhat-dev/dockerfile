# use native build to make sure qemu executable
FROM alpine:latest as downloader

COPY scripts/download.sh /download
RUN set -ex; /download qemu arm64

FROM arm64v8/python:3.6-alpine

# add qemu for cross build
COPY --from=downloader /qemu* /usr/bin/

# install build tools
RUN apk --no-cache add ca-certificates wget build-base curl ;\
    pip3 install pipenv ;

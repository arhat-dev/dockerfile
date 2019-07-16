# use native build to make sure qemu executable
FROM alpine:latest as downloader

RUN wget --quiet -O /qemu-arm-static \
    https://github.com/multiarch/qemu-user-static/releases/download/v4.0.0/qemu-arm-static ;\
    chmod +x /qemu-arm-static

FROM arm32v7/python:3.6-alpine

# add qemu for cross build
COPY --from=downloader /qemu-arm-static  \
    /usr/bin/qemu-arm-static

# install build tools
RUN apk --no-cache add ca-certificates wget build-base curl ;\
    pip3 install pipenv ;

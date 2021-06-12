FROM golang:1.16-alpine3.12

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

# install dependencies
RUN apk --no-cache add \
      ca-certificates wget build-base curl git make ;

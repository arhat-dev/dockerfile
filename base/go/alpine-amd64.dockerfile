FROM golang:1.15-alpine3.11

# install dependencies
RUN apk --no-cache add \
      ca-certificates wget build-base curl git make upx ;

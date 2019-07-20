FROM golang:alpine

# install dependencies
RUN apk --no-cache add \
      ca-certificates wget build-base curl git make upx ;

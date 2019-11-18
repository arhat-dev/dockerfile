ARG ARCH=amd64

FROM arhatdev/builder-go:alpine AS builder
FROM arhatdev/go:alpine-${ARCH}

ENTRYPOINT [ "/hydroxide" ]

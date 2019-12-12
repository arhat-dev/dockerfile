ARG TARGET=yamllint
ARG ARCH=amd64

FROM arhatdev/builder-python3.7:alpine-${ARCH} as builder
FROM arhatdev/python3.7:alpine-${ARCH}

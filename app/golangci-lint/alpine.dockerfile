ARG MATRIX_ARCH
ARG DOCKERHUB_ARCH
ARG GO_VERSION
ARG ALPINE_VERSION

FROM ghcr.io/arhat-dev/builder-go:alpine AS builder

ARG MATRIX_ARCH
COPY . /app
RUN dukkha golang local build golangci-lint -m rootfs=alpine -m kernel=linux -m arch=${MATRIX_ARCH}

# ref: https://github.com/golangci/golangci-lint/blob/master/build/Dockerfile.alpine
FROM docker.io/${DOCKERHUB_ARCH}/golang:${GO_VERSION}-alpine${ALPINE_VERSION}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

RUN apk --no-cache add gcc musl-dev git mercurial

ARG MATRIX_ARCH
COPY --from=builder /app/build/golangci-lint.linux.${MATRIX_ARCH} /golangci-lint

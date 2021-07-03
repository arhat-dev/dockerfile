ARG MATRIX_ARCH
ARG DOCKERHUB_ARCH
ARG GO_VERSION
ARG DEBIAN_VERSION

FROM ghcr.io/arhat-dev/builder-go:debian AS builder

ARG MATRIX_ARCH

COPY . /app
RUN dukkha golang local build golangci-lint -m rootfs=debian -m kernel=linux -m arch=${MATRIX_ARCH}

# ref: https://github.com/golangci/golangci-lint/blob/master/build/Dockerfile
FROM docker.io/${DOCKERHUB_ARCH}/golang:${GO_VERSION}-${DEBIAN_VERSION}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ARCH
COPY --from=builder /app/build/golangci-lint.linux.${MATRIX_ARCH} /golangci-lint

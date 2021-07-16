ARG HOST_ARCH
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-ruby:2.7-debian-${HOST_ARCH}-${MATRIX_ARCH} AS ruby-builder

ARG APP
COPY "build/${APP}" /app

WORKDIR /app
RUN set -eux ;\
    apt-get update ;\
    apt-get install -y cmake ;\
    make /app/.ruby-bundle

FROM ghcr.io/arhat-dev/builder-golang:1.16-debian-${HOST_ARCH}-${MATRIX_ARCH} AS builder

ARG APP

COPY . /app
COPY --from=ruby-builder \
    /app/.ruby-bundle \
    "/app/build/${APP}/.ruby-bundle"

COPY --from=ruby-builder \
    /app/ruby/vendor \
    "/app/build/${APP}/ruby/vendor"

# COPY --from=ruby-builder \
#     /app/ruby/.bundle \
#     "/app/build/${APP}/ruby/.bundle"

ARG MATRIX_ARCH
ARG TARGET_DEBIAN_TRIPLE_NAME
ARG TARGET_GOARCH
RUN set -eux ;\
    apt-get update ;\
    apt-get install -y cmake ;\
    cd "/app/build/${APP}" ;\
    export CGO_ENABLED=1 ;\
    export GOOS=linux ;\
    export GOARCH="${TARGET_GOARCH}" ;\
    export CC="$(command -v ${TARGET_DEBIAN_TRIPLE_NAME}-gcc)" ;\
    export CXX="$(command -v ${TARGET_DEBIAN_TRIPLE_NAME}-g++)" ;\
    make libgit2 ;\
    export PKG_CONFIG_PATH="/app/build/${APP}/_build/deps/libgit2/install/lib/pkgconfig" ;\
    cd /app ;\
    dukkha golang local build \
      "${APP}" \
      -m kernel=linux \
      -m arch=${MATRIX_ARCH}

FROM scratch

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG APP
ARG MATRIX_ARCH
COPY --from=builder /output/${APP}.linux.${MATRIX_ARCH}/* /

# TODO: do we really have to use qemu for ruby gem compilation?

ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-ruby:2.7-debian-${MATRIX_ARCH} AS builder

COPY build/gitaly-ruby/ruby /app

WORKDIR /app
RUN set -eux ;\
    apt-get update ;\
    apt-get install -y cmake ;\
    bundle config set deployment true ;\
    bundle config set without 'development test' ;\
    # bundle config set force_ruby_platform true ;\
    bundle config ;\
    bundle install --jobs 4 ;\
    rm -rf spec features

FROM scratch

# keep gitaly-ruby only
COPY --from=builder /app /

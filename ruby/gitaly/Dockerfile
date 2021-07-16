ARG HOST_ARCH
ARG MATRIX_ARCH

# TODO: ruby have to use qemu for gem compilation, what we can do?
FROM ghcr.io/arhat-dev/builder-ruby:2.7-debian-${MATRIX_ARCH} AS ruby-builder

COPY build/gitaly /app

WORKDIR /app/ruby
RUN set -eux ;\
    apt-get update ;\
    apt-get install -y cmake ;\
# use vendor mode, not to install to /usr/local
# https://gitlab.com/gitlab-org/gitaly/-/blob/master/Makefile#L376
    bundle config set --local deployment false ;\
    bundle config set without 'development test' ;\
    # bundle config set force_ruby_platform true ;\
    bundle config ;\
    bundle install --jobs 4 ;\
    rm -rf spec features

FROM ghcr.io/arhat-dev/builder-golang:1.16-debian-${HOST_ARCH}-${MATRIX_ARCH} AS builder

COPY . /app

ARG MATRIX_ARCH

ENV BUNDLE_FORCE_RUBY_PLATFORM=true
RUN set -eux ;\
    apt-get update ;\
    apt-get install -y cmake ;\
    touch "/app/build/gitaly/.ruby-bundle" ;\
    export PKG_CONFIG_PATH="/app/build/gitaly/_build/deps/libgit2/install/lib/pkgconfig" ;\
    dukkha golang local build gitaly \
      -m kernel=linux \
      -m arch=${MATRIX_ARCH}

FROM ghcr.io/arhat-dev/ruby:2.7-debian-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG APP
ARG MATRIX_ARCH

COPY --from=ruby-builder /app/ruby /srv/gitaly-ruby
COPY --from=builder /output/gitaly.linux.${MATRIX_ARCH}/* /usr/local/bin/
COPY golang/gitlay/config.toml /etc/gitaly/config.toml
COPY golang/gitlay/gitconfig /usr/local/etc/gitconfig
COPY golang/gitlay/healthcheck.sh /usr/local/bin/healthcheck
COPY golang/gitlay/entrypoint.sh /usr/local/bin/entrypoint

RUN set -eux ;\
    adduser --disabled-password --gecos 'GitLab' git ;\
    mkdir -p /home/git/repositories ;\
    sed -i "s/git:!/git:*/" /etc/shadow ;\
    chown -R git:git /etc/gitaly /srv/gitaly-ruby

RUN set -eux ;\
    apt-get update ;\
# install runtime deps
# ref: https://gitlab.com/gitlab-org/build/CNG/-/blob/master/gitaly/Dockerfile#L17
    apt-get install -y --no-install-recommends \
        zlib1g liblzma libmsgpack \
        libicu63 net-tools openssh-client xtail ;\
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/bin/tini", "--", "/usr/local/bin/entrypoint" ]

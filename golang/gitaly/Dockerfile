ARG HOST_ARCH
ARG MATRIX_ARCH

ARG GITLAB_SHELL_VERSION
ARG VERSION

FROM ghcr.io/arhat-dev/gitaly-ruby:${VERSION}-${MATRIX_ARCH} AS gitaly-ruby
FROM ghcr.io/arhat-dev/builder-golang:1.16-debian-${HOST_ARCH}-${MATRIX_ARCH} AS builder

COPY . /app

ARG MATRIX_ARCH

ENV BUNDLE_FORCE_RUBY_PLATFORM=true
RUN set -eux ;\
    apt-get update ;\
    apt-get install -y cmake ;\
    # skip gitaly-ruby build
    touch /app/build/gitaly/.ruby-bundle ;\
    export PKG_CONFIG_PATH="/app/build/gitaly/_build/deps/libgit2/install/lib/pkgconfig" ;\
    dukkha golang local build gitaly \
      -m kernel=linux \
      -m arch=${MATRIX_ARCH}

FROM ghcr.io/arhat-dev/gitlab-shell:${GITLAB_SHELL_VERSION}-${MATRIX_ARCH}
USER root

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ARCH

COPY --from=gitaly-ruby /gitaly-ruby /srv/gitaly-ruby
COPY --from=builder /output/gitaly.linux.${MATRIX_ARCH}/* /usr/local/bin/

COPY golang/gitaly/config.toml /etc/gitaly/config.toml
COPY golang/gitaly/gitconfig /usr/local/etc/gitconfig
COPY golang/gitaly/healthcheck.sh /usr/local/bin/healthcheck
COPY golang/gitaly/entrypoint.sh /usr/local/bin/entrypoint

ENV CONFIG_TEMPLATE_DIRECTORY=/etc/gitaly

RUN set -eux ;\
    mkdir -p /home/git/repositories /var/log/gitaly ;\
    touch /var/log/gitaly/gitaly.log ;\
    touch /var/log/gitaly/gitlab-shell.log ;\
    chown -R git:git /etc/gitaly /srv/gitaly-ruby /var/log/gitaly ;\
    chmod +x /usr/local/bin/entrypoint

RUN set -eux ;\
    apt-get update ;\
# install runtime deps
# ref: https://gitlab.com/gitlab-org/build/CNG/-/blob/master/gitaly/Dockerfile#L17
    apt-get install -y --no-install-recommends \
        libicu63 net-tools openssh-client xtail ;\
    rm -rf /var/lib/apt/lists/*

VOLUME /var/log/gitaly

USER git

ENTRYPOINT [ "/bin/tini", "--", "/usr/local/bin/entrypoint" ]

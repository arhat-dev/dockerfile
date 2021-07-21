ARG MATRIX_ARCH
ARG GITLAB_LOGGER_VERSION
ARG GOMPLATE_VERSION

FROM ghcr.io/arhat-dev/gitlab-logger:${GITLAB_LOGGER_VERSION}-${MATRIX_ARCH} AS gitlab-logger
FROM ghcr.io/arhat-dev/gomplate:${GOMPLATE_VERSION}-${MATRIX_ARCH} AS gomplate
FROM ghcr.io/arhat-dev/builder-golang:1.16-alpine AS builder

ARG MATRIX_ARCH

COPY . /app
RUN dukkha golang local build \
      gitlab-shell \
      -m kernel=linux \
      -m arch=${MATRIX_ARCH} ;\
    rm -rf /app/build/gitlab-shell/internal/testhelper/testdata

FROM ghcr.io/arhat-dev/ruby:2.7-debian-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ARCH

COPY --from=gitlab-logger /gitlab-logger /usr/local/bin/
COPY --from=gomplate /gomplate /usr/local/bin/

# TODO: I have no idea why they are keeping the source directory
#       need to do more investigation before we remove it
COPY --from=builder \
    /app/build/gitlab-shell \
    /srv/gitlab-shell

COPY --from=builder \
    /output/gitlab-shell.linux.${MATRIX_ARCH}/* \
    /srv/gitlab-shell/bin/

COPY golang/gitlab-shell/authorized_keys.sh /authorized_keys
COPY golang/gitlab-shell/sshd_config /etc/ssh/

ENV CONFIG_TEMPLATE_DIRECTORY=/srv/gitlab-shell

RUN set -eux ;\
    # workaround to get rid of intermittent error
    ln -s -f /bin/true /usr/bin/chfn ;\
    adduser --disabled-password --gecos 'GitLab' git ;\
    sed -i 's/git:!/git:*/' /etc/shadow ;\
    apt-get update ;\
    apt-get install -y --no-install-recommends openssh-server ;\
    rm -rf /var/lib/apt/lists/* ;\
    chmod 0755 /authorized_keys ;\
    mkdir -p \
      /srv/sshd \
      /var/log/gitlab-shell ;\
    touch /var/log/gitlab-shell/gitlab-shell.log ;\
    chown -R git:git \
      /var/log/gitlab-shell \
      /srv/gitlab-shell \
      /srv/sshd \
      /etc/ssh

USER git

VOLUME /var/log/gitlab-shell

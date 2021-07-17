ARG MATRIX_ARCH
ARG GITLAB_LOGGER_VERSION
ARG GOMPLATE_VERSION

FROM ghcr.io/arhat-dev/gitlab-logger:${GITLAB_LOGGER_VERSION}-${MATRIX_ARCH} AS gitlab-logger
FROM ghcr.io/arhat-dev/gomplate:${GOMPLATE_VERSION}-${MATRIX_ARCH} AS gomplate
FROM ghcr.io/arhat-dev/builder-golang:1.16-alpine AS builder

ARG MATRIX_ARCH
ARG MATRIX_KERNEL

COPY . /app
RUN dukkha golang local build \
      gitlab-shell \
      -m kernel=${MATRIX_KERNEL} \
      -m arch=${MATRIX_ARCH} ;\
    rm -rf internal/testhelper/testdata

FROM FROM ghcr.io/arhat-dev/ruby:2.7-debian-${MATRIX_ARCH}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_KERNEL
ARG MATRIX_ARCH

COPY --from=gitlab-logger /gitlab-logger /usr/local/bin/
COPY --from=gomplate /gomplate /usr/local/bin/

COPY --from=builder \
    /output/gitlab-shell.${MATRIX_KERNEL}.${MATRIX_ARCH}/* \
    /srv/gitlab-shell/bin/
COPY --from=builder \
    /output

COPY golang/gitlab-shell/authorized_keys.sh /authorized_keys
COPY golang/gitlab-shell/sshd_config /etc/ssh/

RUN set -eux ;\
    adduser --disabled-password --gecos 'GitLab' git ;\
    sed -i "s/git:!/git:*/" /etc/shadow ;\
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

ENV CONFIG_TEMPLATE_DIRECTORY=/srv/gitlab-shell

CMD "/scripts/process-wrapper"

VOLUME /var/log/gitlab-shell

HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
CMD /scripts/healthcheck

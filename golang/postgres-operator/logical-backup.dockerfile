ARG MATRIX_ROOTFS
ARG MATRIX_ARCH

# TODO: keep in sync with postgres-operator/docker/logical-backup
FROM ghcr.io/arhat-dev/golang:1.16-${MATRIX_ROOTFS}-${MATRIX_ARCH}

ARG MATRIX_ROOTFS
RUN set -eux ;\
    if [ "${MATRIX_ROOTFS}" = "debian" ]; then \
      export DEBIAN_FRONTEND=noninteractive ;\
      apt-get update ;\
      apt-get install --no-install-recommends -y \
          apt-utils \
          ca-certificates \
          lsb-release \
          pigz \
          python3-pip \
          python3-setuptools \
          curl \
          jq \
          gnupg \
          gcc \
          libffi-dev ;\
      pip3 install --upgrade pip ;\
      pip3 install --no-cache-dir awscli --upgrade ;\
      pip3 install --no-cache-dir gsutil --upgrade ;\
      echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list ;\
      cat /etc/apt/sources.list.d/pgdg.list ;\
      curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - ;\
      apt-get update ;\
      apt-get install --no-install-recommends -y  \
          postgresql-client-13  \
          postgresql-client-12  \
          postgresql-client-11  \
          postgresql-client-10  \
          postgresql-client-9.6 \
          postgresql-client-9.5 ;\
      apt-get clean ;\
      rm -rf /var/lib/apt/lists/* ;\
    elif [ "${MATRIX_ROOTFS}" = "alpine" ]; then \
      # TODO: support alpine?
      echo "Unsupported rootfs ${MATRIX_ROOTFS}" ;\
      exit 1 ;\
    else \
      echo "Unsupported rootfs ${MATRIX_ROOTFS}" ;\
      exit 1 ;\
    fi

COPY build/postgres-operator/docker/logical-backup/dump.sh /

ENV PG_DIR=/usr/lib/postgresql

ENTRYPOINT ["/dump.sh"]

ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-java:8-debian-${MATRIX_ARCH} AS builder

ENV PATH="/usr/local/maven3/bin:${PATH}"

ARG APP
COPY "build/${APP}" /opendj
WORKDIR /opendj

# Build opendj
ARG VERSION
RUN set -eux ;\
    mvn -V \
      -Dmaven.javadoc.skip=true \
      -DskipTests \
      -Darguments=-DskipTests \
      -Dresume=false \
      -DignoreSnapshots=true \
      -DpushChanges=false \
      -P distribution \
      install ;\
    mkdir -p /opt ;\
    ls -alh **
    # mv build/distribution/local/opendj-${VERSION}-SNAPSHOT \
    #     /opt/opendj ;\

FROM ghcr.io/arhat-dev/java:8-debian-${MATRIX_ARCH}

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'

ARG ADD_BASE_ENTRY="--addBaseEntry"
ARG BASE_DN="dc=example,dc=com"
ARG ROOT_USER_DN="cn=Directory Manager"
ARG ROOT_PASSWORD="password"
ARG SECRET_VOLUME=""
ARG OPENDJ_SSL_OPTIONS="--generateSelfSignedCertificate"
ARG MASTER_SERVER=""
ARG OPENDJ_REPLICATION_TYPE=""
ARG OPENDJ_USER="opendj"

ENV ADD_BASE_ENTRY="${ADD_BASE_ENTRY}" \
    BASE_DN="${BASE_DN}" \
    ROOT_USER_DN="${ROOT_USER_DN}" \
    ROOT_PASSWORD="${ROOT_PASSWORD}" \
    SECRET_VOLUME="${SECRET_VOLUME}" \
    OPENDJ_SSL_OPTIONS="${OPENDJ_SSL_OPTIONS}" \
    MASTER_SERVER="${MASTER_SERVER}" \
    OPENDJ_REPLICATION_TYPE="${OPENDJ_REPLICATION_TYPE}" \
    OPENDJ_USER="opendj"

COPY --from=builder /opt/opendj /opt/opendj

COPY "build/${APP}/opendj-packages/opendj-docker/bootstrap/" \
    /opt/opendj/bootstrap/

COPY "build/${APP}/opendj-packages/opendj-docker/run.sh" \
    /opt/opendj/run.sh

COPY --from=builder --chown=0:0 /bin/tini /bin/tini

RUN set -eux ;\
    groupadd "${OPENDJ_USER}" ;\
    useradd -m -r -u 1001 -g "${OPENDJ_USER}" "${OPENDJ_USER}" ;\
    install -d -o "${OPENDJ_USER}" /opt/opendj/data ;\
    chown -R "${OPENDJ_USER}:${OPENDJ_USER}" /opt/opendj ;\
    chmod -R g=u /opt/opendj ;\
    chmod +x /opt/opendj/run.sh \
     /opt/opendj/bootstrap/setup.sh \
     /opt/opendj/bootstrap/replicate.sh

ENV PORT=1389 \
    LDAPS_PORT=1636

EXPOSE "${PORT}" "${LDAPS_PORT}" 4444

USER 1001

ENTRYPOINT ["/bin/tini", "--", "/opt/opendj/run.sh"]

ARG HOST_ARCH
ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-java:8-debian-${HOST_ARCH} AS builder

ENV MAVEN_OPTS="-Dhttp.keepAlive=false -Dmaven.wagon.http.pool=false" \
    MAVEN_OPTS="${MAVEN_OPTS} -Dmaven.wagon.http.retryHandler.class=standard" \
    MAVEN_OPTS="${MAVEN_OPTS} -Dmaven.wagon.http.retryHandler.count=10"

ENV PATH="/usr/local/maven3/bin:${PATH}"

# build opendj
COPY build/opendj /opendj
WORKDIR /opendj
ARG VERSION
RUN set -eux ;\
    apt-get update ;\
    apt-get install unzip ;\
    mvn -V clean install \
      -Dmaven.test.skip=true \
      -Dmaven.javadoc.skip=true \
      -DskipTests \
      -Dresume=false \
      -DignoreSnapshots=true \
      -DpushChanges=false \
      -P distribution ;\
    unzip -d /opt/opendj-tmp /opendj/opendj-server-legacy/target/package/opendj-${VERSION}.zip ;\
    mv /opt/opendj-tmp/* /opt/opendj ;\
    mv /opendj/opendj-packages/opendj-docker/bootstrap/ \
        /opt/opendj/bootstrap/ ;\
    mv /opendj/opendj-packages/opendj-docker/run.sh \
        /opt/opendj/run.sh

RUN set -eux ;\
    chmod +x /opt/opendj/run.sh \
        /opt/opendj/bootstrap/setup.sh \
        /opt/opendj/bootstrap/replicate.sh

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

ENV ADD_BASE_ENTRY="${ADD_BASE_ENTRY}" \
    BASE_DN="${BASE_DN}" \
    ROOT_USER_DN="${ROOT_USER_DN}" \
    ROOT_PASSWORD="${ROOT_PASSWORD}" \
    SECRET_VOLUME="${SECRET_VOLUME}" \
    OPENDJ_SSL_OPTIONS="${OPENDJ_SSL_OPTIONS}" \
    MASTER_SERVER="${MASTER_SERVER}" \
    OPENDJ_REPLICATION_TYPE="${OPENDJ_REPLICATION_TYPE}" \
    OPENDJ_USER="opendj" \
    PORT=1389 \
    LDAPS_PORT=1636

COPY --from=builder /opt/opendj /opt/opendj
RUN set -eux ;\
    addgroup --gid 1001 opendj ;\
    adduser --system --no-create-home \
        --shell "$(which false)" \
        --disabled-password \
        --uid 1001 opendj ;\
    adduser opendj opendj ;\
    mkdir -p /opt/opendj/data ;\
    chown -R opendj:opendj /opt/opendj ;\
    chmod -R g=u /opt/opendj

USER 1001

# expose ldap-port ldaps-port initial-cluster-port
EXPOSE "${PORT}" "${LDAPS_PORT}" 4444

ENTRYPOINT ["/bin/tini", "--", "/opt/opendj/run.sh"]

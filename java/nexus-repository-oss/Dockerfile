ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-java:8-debian-${MATRIX_ARCH} AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN set -ex ;\
    curl -sL https://deb.nodesource.com/setup_14.x \
    -o /nodesource_setup.sh ;\
    bash /nodesource_setup.sh ;\
    apt-get update ;\
    apt-get install -y nodejs unzip ;\
    npm install -g yarn

# build keycloak plugin
ENV PATH="/usr/local/maven3/bin:${PATH}"
COPY build/nexus3-keycloak-plugin /keycloak-plugin
WORKDIR /keycloak-plugin
RUN set -eux ;\
    mvn clean install \
      -Dmaven.test.skip=true \
      -Dmaven.javadoc.skip=true \
      -DskipTests \
      -Dresume=false \
      -DignoreSnapshots=true \
      -DpushChanges=false

# build nexus3
ARG VERSION
COPY build/nexus-public /nexus
WORKDIR /nexus
RUN set -eux ;\
    ./mvnw -V clean install \
      -Dmaven.test.skip=true \
      -Dmaven.javadoc.skip=true \
      -DskipTests \
      -Dresume=false \
      -DignoreSnapshots=true \
      -DpushChanges=false ;\
    unzip -d /opt/nexus-tmp assemblies/nexus-base-template/target/nexus-base-template-*.zip ;\
    mv /opt/nexus-tmp/nexus-base-template* /opt/nexus

FROM ghcr.io/arhat-dev/java:8-debian-${MATRIX_ARCH}

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'

# configure nexus runtime
# ref: https://github.com/sonatype/docker-nexus3/blob/master/Dockerfile
ENV SONATYPE_DIR=/opt/sonatype
ENV NEXUS_HOME="${SONATYPE_DIR}/nexus" \
    NEXUS_DATA=/nexus-data \
    NEXUS_CONTEXT='' \
    SONATYPE_WORK="${SONATYPE_DIR}/sonatype-work" \
    INSTALL4J_ADD_VM_PARAMS="-Xms2703m -Xmx2703m -XX:MaxDirectMemorySize=2703m -Djava.util.prefs.userRoot=/nexus-data/javaprefs"
# this variable is only consumed by chef
# DOCKER_TYPE='3x-docker'

ARG KEYCLOAK_PLUGIN_VERSION

COPY --from=builder /opt/nexus "${NEXUS_HOME}"
COPY --from=builder \
    "/keycloak-plugin/target/nexus3-keycloak-plugin-${KEYCLOAK_PLUGIN_VERSION}.jar" \
    "${NEXUS_HOME}/system/org/github/flytreeleft/nexus3-keycloak-plugin/nexus3-keycloak-plugin-${KYECLOAK_PLUGIN_VERSION}.jar"

COPY java/nexus-repository-oss/nexus.vmoptions "${NEXUS_HOME}/bin/nexus.vmoptions"
COPY java/nexus-repository-oss/entrypoint.sh "${SONATYPE_DIR}/start-nexus-repository-manager.sh"

RUN set -eux ;\
# ref: https://github.com/sonatype/chef-nexus-repository-manager/blob/master/recipes/users.rb
    addgroup --gid 200 nexus ;\
    adduser --system --home "${NEXUS_HOME}" \
        --shell "$(which false)" \
        --disabled-password \
        --uid 200 nexus ;\
    adduser nexus nexus ;\
# I personaly don't like this and have no idea why not chown -R nexus:nexus NEXUS_HOME,
# ref: https://github.com/sonatype/chef-nexus-repository-manager/blob/master/recipes/3x-docker.rb#L44
    adduser nexus root ;\
    mkdir -p "${SONATYPE_WORK}" \
        "${NEXUS_DATA}/etc" "${NEXUS_DATA}/log" "${NEXUS_DATA}/tmp" ;\
    ln -s "${NEXUS_DATA}" "${SONATYPE_WORK}/nexus3" ;\
    chmod 0755 "${SONATYPE_DIR}" "${SONATYPE_WORK}" "${NEXUS_HOME}" ;\
    chmod -R 0755 "${NEXUS_DATA}" ;\
    chown -R nexus:nexus "${NEXUS_DATA}" ;\

USER 200
EXPOSE 8081

VOLUME "${NEXUS_DATA}"

ENTRYPOINT ["/bin/tini", "--", "/opt/sonatype/start-nexus-repository-manager.sh"]

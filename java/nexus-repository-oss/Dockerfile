ARG HOST_ARCH
ARG MATRIX_ARCH

# TODO: nexus uses nodejs, we have to compile in qemu
#       to get native js dependencies working
FROM ghcr.io/arhat-dev/builder-java:8-debian-${HOST_ARCH} AS builder

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
# we are using nexus v3.15+ use kar instead of jar
    mvn -PbuildKar clean package \
      -Dhttp.keepAlive=false -Dmaven.wagon.http.pool=false \
      -Dmaven.wagon.http.retryHandler.class=standard \
      -Dmaven.wagon.http.retryHandler.count=10 \
      -Dmaven.test.skip=true \
      -Dmaven.javadoc.skip=true \
      -DskipTests \
      -Dresume=false \
      -DignoreSnapshots=true \
      -DpushChanges=false

# build nexus3
COPY build/nexus-public /nexus
WORKDIR /nexus
RUN set -eux ;\
    ./mvnw clean install \
      -Dhttp.keepAlive=false -Dmaven.wagon.http.pool=false \
      -Dmaven.wagon.http.retryHandler.class=standard \
      -Dmaven.wagon.http.retryHandler.count=10 \
      -Dmaven.test.skip=true \
      -Dmaven.javadoc.skip=true \
      -DskipTests \
      -Dresume=false \
      -DignoreSnapshots=true \
      -DpushChanges=false ;\
    unzip -d /opt/nexus-tmp assemblies/nexus-base-template/target/nexus-base-template-*.zip ;\
    mv /opt/nexus-tmp/nexus-base-template* /opt/nexus

# Ref: https://github.com/klo2k/nexus3-docker/blob/master/Dockerfile
# Fix-up: Startup error with OrientDB on ARM - replace in-place 5.4.0 with 5.5.0 lib (reference is hard-coded in config files)
# http://bhamail.github.io/pinexus/nexussetup.html
ADD https://repo1.maven.org/maven2/net/java/dev/jna/jna/5.5.0/jna-5.5.0.jar \
    /opt/nexus/system/net/java/dev/jna/jna/5.4.0/jna-5.4.0.jar
ADD https://repo1.maven.org/maven2/net/java/dev/jna/jna-platform/5.5.0/jna-platform-5.5.0.jar \
    /opt/nexus/system/net/java/dev/jna/jna-platform/5.4.0/jna-platform-5.4.0.jar

RUN chmod 644 \
      /opt/nexus/system/net/java/dev/jna/jna/5.4.0/jna-5.4.0.jar \
      /opt/nexus/system/net/java/dev/jna/jna-platform/5.4.0/jna-platform-5.4.0.jar

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
    "/keycloak-plugin/target/nexus3-keycloak-plugin-${KEYCLOAK_PLUGIN_VERSION}-bundle.kar" \
    "${NEXUS_HOME}/deploy/"

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
    chmod 0755 "${SONATYPE_DIR}" "${SONATYPE_WORK}" "${NEXUS_HOME}" \
        "${SONATYPE_DIR}/start-nexus-repository-manager.sh" ;\
    chmod -R 0755 "${NEXUS_DATA}" ;\
    chown -R nexus:nexus "${NEXUS_DATA}"

USER 200
EXPOSE 8081

# mount "${NEXUS_HOME}/etc/keycloak.json" to get keycloak working
VOLUME "${NEXUS_DATA}"

ENTRYPOINT ["/bin/tini", "--", "/opt/sonatype/start-nexus-repository-manager.sh"]

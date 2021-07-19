ARG MATRIX_ARCH

# TODO: sonarqube uses nodejs, we have to compile in qemu
#       to get native js dependencies working
FROM ghcr.io/arhat-dev/builder-java:11-debian-${MATRIX_ARCH} AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN set -ex ;\
    curl -sL https://deb.nodesource.com/setup_14.x \
        -o /nodesource_setup.sh ;\
    bash /nodesource_setup.sh ;\
    apt-get update ;\
    apt-get install -y nodejs unzip ;\
    npm install -g yarn

ARG APP
COPY build/${APP} /build
WORKDIR /build

# Build sonarqube
ARG ES_CHECKSUM
ARG ES_DOWNLOAD_URL_PATH
ARG ES_DOWNLOAD_URL_FILE
RUN set -ex ;\
    if [ "${HOST_ARCH}" != "${MATRIX_ARCH}" ]; then \
        export CC="${TARGET_DEBIAN_TRIPLE_NAME}-gcc" ;\
        export CXX="${TARGET_DEBIAN_TRIPLE_NAME}-g++" ;\
    fi ;\
    # tests disabled due to failure under container environment
    ./gradlew build -x test \
        --no-daemon --info --console plain \
        "-PelasticsearchDownloadUrlPath=${ES_DOWNLOAD_URL_PATH}" \
        "-PelasticsearchDownloadUrlFile=${ES_DOWNLOAD_URL_FILE}" \
        "-PelasticsearchDownloadSha512=${ES_CHECKSUM}" ;\
    mkdir -p /expanded ;\
    mv /build/sonar-application/build/distributions/sonar-application*.zip \
        /expanded/sonarqube.zip ;\
    cd /expanded ;\
    unzip /expanded/sonarqube.zip ;\
    rm -f /expanded/sonarqube.zip ;\
    # should only have one directory
    mv /expanded/sonarqube-* /expanded/sonarqube

COPY java/sonarqube/run.sh java/sonarqube/sonar.sh \
    /expanded/sonarqube/bin

FROM ghcr.io/arhat-dev/java:11-debian-${MATRIX_ARCH}

# reference:
# https://github.com/SonarSource/docker-sonarqube/blob/master/9/community/Dockerfile
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'

# cannot set version, will cause lib/sonar-application-9.0-${VERSION}.jar
# not found at runtime, use value 9.0-SNAPSHOT as a wrokaround
# ARG VERSION
ENV SONARQUBE_HOME=/opt/sonarqube
# SONAR_VERSION="${VERSION}" \
ENV SONAR_VERSION="9.0-SNAPSHOT" \
    SQ_DATA_DIR="${SONARQUBE_HOME}/data" \
    SQ_EXTENSIONS_DIR="${SONARQUBE_HOME}/extensions" \
    SQ_LOGS_DIR="${SONARQUBE_HOME}/logs" \
    SQ_TEMP_DIR="${SONARQUBE_HOME}/temp"

RUN set -ex ;\
    echo "networkaddress.cache.ttl=5" >> "${JAVA_HOME}/conf/security/java.security"; \
    sed --in-place \
        --expression="s?securerandom.source=file:/dev/random?securerandom.source=file:/dev/urandom?g" \
        "${JAVA_HOME}/conf/security/java.security";

COPY --from=builder /expanded/sonarqube "${SONARQUBE_HOME}"

WORKDIR /opt
RUN set -eux ;\
    addgroup --system --gid 1000 sonarqube ;\
    adduser --system --disabled-login --uid 1000 --gid 1000 sonarqube ;\
    adduser sonarqube sonarqube ;\
    chown -R sonarqube:sonarqube "${SONARQUBE_HOME}" ;\
    # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)
    chmod -R 777 "${SQ_DATA_DIR}" "${SQ_EXTENSIONS_DIR}" \
        "${SQ_LOGS_DIR}" "${SQ_TEMP_DIR}" ;\
    chmod 0755 "${SONARQUBE_HOME}/bin/run.sh" "${SONARQUBE_HOME}/bin/sonar.sh"

WORKDIR "${SONARQUBE_HOME}"
EXPOSE 9000

# use number for kubernetes runAsNonRoot=true check
USER 1000

ENTRYPOINT ["/bin/tini", "--" ,"/opt/sonarqube/bin/run.sh"]
CMD ["/opt/sonarqube/bin/sonar.sh"]

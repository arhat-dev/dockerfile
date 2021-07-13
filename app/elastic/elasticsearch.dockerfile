ARG DOCKERHUB_ARCH
ARG MATRIX_JDK
ARG MATRIX_JRE

FROM docker.io/${DOCKERHUB_ARCH}/adoptopenjdk:${MATRIX_JDK} AS builder

# ENV DEBIAN_FRONTEND=noninteractive
# RUN set -ex ;\
#     curl -sL https://deb.nodesource.com/setup_14.x \
#     -o /nodesource_setup.sh ;\
#     bash /nodesource_setup.sh ;\
#     apt-get update ;\
#     apt-get install -y nodejs ;\
#     npm install -g yarn

ARG APP
COPY build/${APP} /build
WORKDIR /build

# Build elasticsearch
# ref:
#   https://github.com/elastic/elasticsearch/blob/master/.ci/jobs.t/elastic%2Belasticsearch%2Bmultijob%2Bpackaging-tests-unix.yml
#   https://github.com/elastic/elasticsearch/blob/master/.ci/os.sh
RUN set -ex ;\
    # tests disabled due to failure under container environment
    ./gradlew localDistro -x test \
        --no-daemon --scan --console plain
#
# FROM docker.io/${DOCKERHUB_ARCH}/adoptopenjdk:${MATRIX_JRE}
#
# # reference:
# # https://github.com/SonarSource/docker-sonarqube/blob/master/9/community/Dockerfile
# ENV LANG='en_US.UTF-8' \
#     LANGUAGE='en_US:en' \
#     LC_ALL='en_US.UTF-8'
#
# ARG VERSION
# ENV SONARQUBE_HOME=/opt/sonarqube \
#     SONAR_VERSION="${VERSION}" \
#     SQ_DATA_DIR="/opt/sonarqube/data" \
#     SQ_EXTENSIONS_DIR="/opt/sonarqube/extensions" \
#     SQ_LOGS_DIR="/opt/sonarqube/logs" \
#     SQ_TEMP_DIR="/opt/sonarqube/temp"
#
# RUN set -ex ;\
#     echo "networkaddress.cache.ttl=5" >> "${JAVA_HOME}/conf/security/java.security"; \
#     sed --in-place \
#         --expression="s?securerandom.source=file:/dev/random?securerandom.source=file:/dev/urandom?g" \
#         "${JAVA_HOME}/conf/security/java.security";
#
# COPY --from=builder \
#     /build/sonar-application/build/distributions/sonar-application*.zip \
#     /opt/
#
# WORKDIR /opt
# RUN set -eux ;\
#     apt-get update ;\
#     apt-get install unzip ;\
#     unzip /opt/sonar-application*.zip ;\
#     apt-get autoremove -y unzip ;\
#     rm -rf /var/lib/apt/lists/* /opt/sonar-application* ;\
#     mv sonarqube-* "${SONARQUBE_HOME}" ;\
#     addgroup --system --gid 1000 sonarqube ;\
#     adduser --system --disabled-login --uid 1000 --gid 1000 sonarqube ;\
#     adduser sonarqube sonarqube ;\
#     chown -R sonarqube:sonarqube "${SONARQUBE_HOME}" ;\
#     # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)
#     chmod -R 777 \
#         "${SQ_DATA_DIR}" \
#         "${SQ_EXTENSIONS_DIR}" \
#         "${SQ_LOGS_DIR}" \
#         "${SQ_TEMP_DIR}"
#
# COPY --chown=sonarqube:sonarqube \
#     app/sonarqube/ce-run.sh ${SONARQUBE_HOME}/bin/run.sh
#
# COPY --chown=sonarqube:sonarqube \
#     app/sonarqube/ce-sonar.sh ${SONARQUBE_HOME}/bin/sonar.sh
#
# RUN set -ex;
#     chmod 0755 \
#         ${SONARQUBE_HOME}/bin/run.sh \
#         ${SONARQUBE_HOME}/bin/sonar.sh
#
# WORKDIR ${SONARQUBE_HOME}
# EXPOSE 9000
#
# USER 1000
#
# ENTRYPOINT ["/opt/sonarqube/bin/run.sh"]
# CMD ["/opt/sonarqube/bin/sonar.sh"]

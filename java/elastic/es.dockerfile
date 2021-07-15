ARG MATRIX_ARCH

FROM ghcr.io/arhat-dev/builder-java:16-debian-${MATRIX_ARCH} AS builder

ARG APP
COPY build/${APP} /es
WORKDIR /es

# Build elasticsearch
ARG VERSION
RUN set -eux ;\
    # tests disabled due to failure under container environment
    ./gradlew localDistro -x test \
        --no-daemon --info --console plain ;\
    mkdir -p /opt ;\
    mv "build/distribution/local/elasticsearch-${VERSION}-SNAPSHOT" \
        /opt/es ;\
    rm -rf /opt/es/jdk

# override default values
COPY java/elastic/es.log4j2.docker.properties \
    /opt/es/config/log4j2.properties

COPY java/elastic/es.yml \
    /opt/es/config/elasticsearch.yml

WORKDIR /opt/es
# ref: https://github.com/elastic/dockerfiles/blob/7.13/elasticsearch/Dockerfile
RUN set -eux ;\
    sed -i -e 's/ES_DISTRIBUTION_TYPE=tar/ES_DISTRIBUTION_TYPE=docker/' \
        bin/elasticsearch-env ;\
    mkdir -p config/jvm.options.d data logs plugins ;\
    chmod 0775 config config/jvm.options.d data logs plugins ;\
    chmod 0660 config/elasticsearch.yml config/log4j2.properties ;\
    find . -xdev -perm -4000 -exec chmod ug-s {} + && \
    find . -type f -exec chmod o+r {} +

FROM ghcr.io/arhat-dev/java:16-debian-${MATRIX_ARCH}

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'

ENV ELASTIC_CONTAINER=true
ENV PATH="/usr/share/elasticsearch/bin:${PATH}"

COPY --from=builder /opt/es /usr/share/elasticsearch
COPY java/elastic/es-entrypoint.sh \
    /usr/local/bin/entrypoint

RUN set -ex ;\
    addgroup --gid 1000 elasticsearch ;\
    adduser --uid 1000 --gid 1000 \
        --home /usr/share/elasticsearch \
        elasticsearch ;\
    adduser elasticsearch root ;\
    adduser elasticsearch elasticsearch ;\
    chmod 0775 /usr/share/elasticsearch ;\
    chown -R 1000:0 /usr/share/elasticsearch ;\
    chmod g=u /etc/passwd ;\
    chmod 0775 /usr/local/bin/entrypoint ;\
    find / -xdev -perm -4000 -exec chmod ug-s {} +

EXPOSE 9200 9300

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/entrypoint"]
# Dummy overridable parameter parsed by entrypoint
CMD ["eswrapper"]

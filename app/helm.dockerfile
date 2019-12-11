ARG ARCH=amd64

# we cannot build conftest yet, so it's not supported
# FROM arhatdev/conftest:${ARCH} AS conftest
FROM arhatdev/kubeval:${ARCH} AS kubeval
FROM arhatdev/helms3:${ARCH} AS helms3

FROM alpine:latest AS builder

ARG ARCH=amd64
COPY scripts/download.sh /download
RUN set -ex ;\
    /download helm ${ARCH} ;\
    /download qemu ${ARCH} ;\
    /download kubectl ${ARCH} ;\
    mkdir -p /app/build/ ;\
    mv /helm/helm /app/build/helm-linux-${ARCH}

FROM arhatdev/go:alpine-${ARCH}

# COPY --from=conftest /conftest /usr/bin/conftest
COPY --from=kubeval /kubeval /usr/bin/kubeval
COPY --from=helms3 /helms3 /usr/bin/helms3
COPY --from=builder /kubectl/kubectl /usr/bin/kubectl
COPY --from=builder /qemu* /usr/bin/

ENV HELM_HOME /root/.local/share/helm
ENV S3_PLUGIN_DIR ${HELM_HOME}/plugins/helm-s3
ENV KUBEVAL_PLUGIN_DIR ${HELM_HOME}/plugins/helm-kubeval
ENV CONFTEST_PLUGIN_DIR ${HELM_HOME}/plugins/helm-conftest

RUN set -ex ;\
    apk add --no-cache git bash ;\
    ln -s /helm /usr/bin/helm ;\
    mkdir -p ${S3_PLUGIN_DIR}/bin ${S3_PLUGIN_DIR}/scripts ;\
    wget -O - https://raw.githubusercontent.com/hypnoglow/helm-s3/master/plugin.yaml > ${S3_PLUGIN_DIR}/plugin.yaml ;\
    ln -s /usr/bin/helms3 "${S3_PLUGIN_DIR}/bin/helms3" ;\
    # mkdir -p ${CONFTEST_PLUGIN_DIR}/{bin,scripts} ;\
    # curl -fsSL https://raw.githubusercontent.com/instrumenta/helm-conftest/master/plugin.yaml > ${CONFTEST_PLUGIN_DIR}/plugin.yaml ;\
    # curl -fsSL https://raw.githubusercontent.com/instrumenta/helm-conftest/master/scripts/run.sh > ${CONFTEST_PLUGIN_DIR}/scripts/run.sh ;\
    # ln -s "${CONFTEST_PLUGIN_DIR}/bin/conftest" /usr/bin/conftest ;\
    mkdir -p ${KUBEVAL_PLUGIN_DIR}/bin ${KUBEVAL_PLUGIN_DIR}/scripts ;\
    wget -O - https://raw.githubusercontent.com/instrumenta/helm-kubeval/master/plugin.yaml > ${KUBEVAL_PLUGIN_DIR}/plugin.yaml ;\
    wget -O - https://raw.githubusercontent.com/instrumenta/helm-kubeval/master/scripts/run.sh > ${KUBEVAL_PLUGIN_DIR}/scripts/run.sh ;\
    ln -s /usr/bin/kubeval "${KUBEVAL_PLUGIN_DIR}/bin/kubeval" ;\
    chmod +x ${KUBEVAL_PLUGIN_DIR}/scripts/run.sh ;

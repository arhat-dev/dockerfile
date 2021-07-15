ARG BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ROOTFS
ARG PROGRAMMING_LANGUAGE

COPY "common/setup-${MATRIX_ROOTFS}-cross.sh" /setup.sh
COPY "${PROGRAMMING_LANGUAGE}/_base/setup-cross.sh" /setup-language.sh

ARG HOST_ARCH
ARG CROSS_ARCH
ARG CROSS_TRIPLE_NAME

ARG MATRIX_ARCH
ARG MATRIX_CROSS_ARCH

# for java
ARG MAVEN3_VERSION

RUN set -eux ;\
    sh /setup.sh "${HOST_ARCH}" "${CROSS_ARCH}" "${CROSS_TRIPLE_NAME}" ;\
    sh /setup-language.sh "${MATRIX_ARCH}" "${MATRIX_CROSS_ARCH}" ;\
    rm -f /setup*.sh

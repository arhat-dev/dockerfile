ARG BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

ARG MATRIX_ROOTFS
ARG PROGRAMMING_LANGUAGE

COPY "common/base-cross-setup.sh" /setup.sh
COPY "${PROGRAMMING_LANGUAGE}/_common/base-setup.sh" /setup-custom.sh
COPY "${PROGRAMMING_LANGUAGE}/_common/base-cross-setup.sh" /setup-custom-cross.sh

ARG HOST_ARCH
ARG CROSS_ARCH
ARG CROSS_TRIPLE_NAME

ARG MATRIX_ARCH
ARG MATRIX_CROSS_ARCH
ARG MATRIX_ROOTFS_VERSION

# for java
ARG MAVEN3_VERSION

RUN set -eux ;\
    sh /setup.sh \
        "${MATRIX_ROOTFS}" "${MATRIX_ARCH}" "${MATRIX_CROSS_ARCH}" \
        "${MATRIX_ROOTFS_VERSION}" \
        "${HOST_ARCH}" "${CROSS_ARCH}" "${CROSS_TRIPLE_NAME}" ;\
    sh /setup-custom.sh \
        "${MATRIX_ROOTFS}" "${MATRIX_ARCH}" "${HOST_ARCH}" ;\
    sh /setup-custom-cross.sh \
        "${MATRIX_ROOTFS}" "${MATRIX_ARCH}" "${MATRIX_CROSS_ARCH}" \
        "${MATRIX_ROOTFS_VERSION}" \
        "${HOST_ARCH}" "${CROSS_ARCH}" "${CROSS_TRIPLE_NAME}" ;\
    rm -f /setup*.sh

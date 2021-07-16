ARG BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

# ARG QEMU_ARCH
# ARG QEMU_VERSION
# # TODO: compile and add arm64 qemu support
# COPY --from=docker.io/multiarch/qemu-user-static:x86_64-${QEMU_ARCH}-${QEMU_VERSION} \
#     /usr/bin/qemu* /usr/bin/

ARG PROGRAMMING_LANGUAGE

COPY "common/base-setup.sh" /setup.sh
COPY "${PROGRAMMING_LANGUAGE}/_common/base-setup.sh" /setup-custom.sh

# for java
ARG MAVEN3_VERSION

ARG MATRIX_ROOTFS
ARG MATRIX_ARCH
ARG HOST_ARCH

RUN set -eux ;\
    sh /setup.sh \
        "${MATRIX_ROOTFS}" "${MATRIX_ARCH}" "${HOST_ARCH}" ;\
    sh /setup-custom.sh \
        "${MATRIX_ROOTFS}" "${MATRIX_ARCH}" "${HOST_ARCH}" ;\
    rm -f /setup*.sh

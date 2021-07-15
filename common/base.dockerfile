ARG BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

# ARG QEMU_ARCH
# ARG QEMU_VERSION
# # TODO: compile and add arm64 qemu support
# COPY --from=docker.io/multiarch/qemu-user-static:x86_64-${QEMU_ARCH}-${QEMU_VERSION} \
#     /usr/bin/qemu* /usr/bin/

ARG MATRIX_ROOTFS
ARG PROGRAMMING_LANGUAGE

COPY "common/setup-${MATRIX_ROOTFS}.sh" /setup.sh
COPY "${PROGRAMMING_LANGUAGE}/_base/setup.sh" /setup-language.sh

# for java
ARG MAVEN3_VERSION

RUN set -eux ;\
    sh /setup.sh ;\
    sh /setup-language.sh ;\
    rm -f /setup*.sh

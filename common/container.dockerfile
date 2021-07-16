ARG BASE_IMAGE

FROM ${BASE_IMAGE} AS builder

WORKDIR /app

ARG PROGRAMMING_LANGUAGE
COPY "${PROGRAMMING_LANGUAGE}/_common/container-setup.sh" \
    /setup-custom.sh

COPY "${PROGRAMMING_LANGUAGE}/_common/container-entrypoint.sh" \
    /usr/local/bin/entrypoint

COPY common/container-setup.sh \
    /setup.sh

ARG MATRIX_ROOTFS
ARG MATRIX_ARCH
ARG HOST_ARCH

# for tini installation
ARG TINI_VERSION
ARG MATRIX_ROOTFS
RUN set -eux ;\
    sh /setup.sh "${MATRIX_ROOTFS}" "${MATRIX_ARCH}" "${HOST_ARCH}" ;\
    sh /setup-custom.sh "${MATRIX_ROOTFS}" "${MATRIX_ARCH}" "${HOST_ARCH}" ;\
    rm -f /setup*.sh ;\
    chmod a+x /usr/local/bin/entrypoint

# TODO: shrink the final image by copy whole rootfs to scratch
#       need to find a way to keep all environment variables
# FROM scratch
# COPY --from=builder / /

ENTRYPOINT [ "/bin/tini", "--", "/usr/local/bin/entrypoint" ]

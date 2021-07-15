ARG BASE_IMAGE

FROM ${BASE_IMAGE} AS builder

WORKDIR /app

ARG PROGRAMMING_LANGUAGE
COPY "${PROGRAMMING_LANGUAGE}/_container/setup.sh" \
    /setup.sh

COPY "${PROGRAMMING_LANGUAGE}/_container/entrypoint.sh" \
    /usr/local/bin/entrypoint

ARG MATRIX_ARCH

# for java
ARG TINI_VERSION
RUN set -eux ;\
    sh /setup.sh "${MATRIX_ARCH}" && rm -f /setup.sh ;\
    chmod a+x /usr/local/bin/entrypoint

# TODO: shrink the final image by copy whole rootfs to scratch
#       need to find a way to keep all environment variables
# FROM scratch
# COPY --from=builder / /

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]

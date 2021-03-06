ARG DUKKHA_IMAGE
ARG BASE_IMAGE

FROM ${DUKKHA_IMAGE} as dukkha
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.source https://github.com/arhat-dev/dockerfile

COPY --from=dukkha /dukkha /usr/local/bin/dukkha

ARG PROGRAMMING_LANGUAGE

COPY "${PROGRAMMING_LANGUAGE}/_common/build.sh" /build.sh
RUN set -eux ;\
    chmod +x /usr/local/bin/dukkha

WORKDIR /app

ARG DOCKER_ARCH=amd64

FROM alpine:latest AS downloader

ARG ARCH=amd64

COPY scripts/download.sh /download
RUN set -ex ;\
    /download github_runner ${ARCH} ;

FROM ${DOCKER_ARCH}/ubuntu:18.04

COPY --from=downloader /github-runner /github-runner

ENTRYPOINT [ "/bin/bash", "/github-runner/run.sh" ]

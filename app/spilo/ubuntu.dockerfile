ARG DOCKERHUB_ARCH

FROM docker.io/${DOCKERHUB_ARCH}/ubuntu:20.04 as base

# TODO: very strange, spilo build will error if this directory is not removed
#       they are using `rm -rf` as well
RUN rm -rf /usr/share/man

FROM scratch

COPY --from=base / /

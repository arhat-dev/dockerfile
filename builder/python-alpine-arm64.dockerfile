# use native build to make sure qemu executable
FROM alpine:3.9 as downloader

RUN wget --quiet -O /qemu-aarch64-static \
    https://github.com/multiarch/qemu-user-static/releases/download/v4.0.0/qemu-aarch64-static ;\
    chmod +x /qemu-aarch64-static

FROM arhatdev/base-python-alpine-arm64:latest

# add qemu for cross build
COPY --from=downloader /qemu-aarch64-static  \
    /usr/bin/qemu-aarch64-static

# install build tools
RUN apk --no-cache add ca-certificates wget build-base curl ;\
    pip3 install pipenv ;

# ensure pipenv will create vitrualenv in /app/.venv
ENV PIPENV_VENV_IN_PROJECT 1

WORKDIR /app

ONBUILD COPY . /app
ONBUILD ARG TARGET
ONBUILD RUN \
  if [ ! -z "${TARGET}" ]; then \
    pipenv install ;\
  fi

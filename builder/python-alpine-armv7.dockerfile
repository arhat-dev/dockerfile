FROM arhatdev/base-python-alpine-armv7:latest

# add qemu for cross build
ADD https://github.com/multiarch/qemu-user-static/releases/download/v4.0.0/qemu-arm-static \
    /usr/bin/qemu-arm-static

# install build tools
RUN chmod +x /usr/bin/qemu-arm-static ;\
    apk --no-cache add ca-certificates wget build-base curl ;\
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

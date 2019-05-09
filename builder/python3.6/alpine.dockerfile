ARG ARCH=amd64
FROM arhatdev/base-python3.6-alpine-${ARCH}:latest

# ensure pipenv will create vitrualenv in /app/.venv
ENV PIPENV_VENV_IN_PROJECT 1

WORKDIR /app

ONBUILD COPY . /app
ONBUILD ARG TARGET
ONBUILD RUN \
  if [ ! -z "${TARGET}" ]; then \
    pipenv install ;\
  fi ;\
  # delete cache
  find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' + ;\
  find /app -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' + ;

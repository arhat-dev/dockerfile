FROM docker.io/${dockerhub_arch}/python:${py_ver}-${suffix}

WORKDIR /app

ARG PROGRAMMING_LANGUAGE
COPY "${PROGRAMMING_LANGUAGE}/_container/entrypoint.sh" /usr/local/bin/entrypoint
RUN chmod a+x /usr/local/bin/entrypoint

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]

ARG ARCH=amd64
# docker flavored arch name
ARG DOCKER_ARCH=amd64

FROM arhatdev/builder-python3.7-alpine-${ARCH}:onbuild as builder
FROM ${DOCKER_ARCH}/python:3.7-alpine3.9

ONBUILD COPY --from=builder /app /app

WORKDIR /app

COPY python-entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "python", "/app/main.py" ]

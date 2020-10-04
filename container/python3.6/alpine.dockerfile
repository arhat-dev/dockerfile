ARG ARCH=amd64
# docker flavored arch name
ARG DOCKER_ARCH=amd64

FROM arhatdev/builder-python3.6:alpine as builder
FROM ${DOCKER_ARCH}/python:3.6-alpine3.11

ONBUILD COPY --from=builder /app /app

WORKDIR /app

COPY scripts/python/entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "python", "/app/main.py" ]

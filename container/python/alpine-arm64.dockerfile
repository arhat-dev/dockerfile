FROM arhatdev/builder-python-alpine-arm64:onbuild as builder
FROM arm64v8/python:3.7-alpine3.9

ONBUILD COPY --from=builder /app /app

WORKDIR /app

COPY container/python/entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "python", "/app/main.py" ]

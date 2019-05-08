FROM arhatdev/builder-python-arm32v7:onbuild as builder
FROM arm32v7/alpine:3.9

ONBUILD COPY --from=builder /app /app
ONBUILD RUN . /app/.venv/bin/activate

WORKDIR /app

ENTRYPOINT [ "sh", "-c" ]
CMD [ "python3", "main.py" ]
